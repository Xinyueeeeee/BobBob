import Foundation
import Combine

final class SchedulerViewModel: ObservableObject {

    @Published var scheduledBlocks: [ScheduledBlock] = []

    @Published var failedTasks: [Task] = []
    @Published var showFailedAlert: Bool = false
    @Published var failedReasonMessages: [String] = []

    @Published var conflictBlocks: [ScheduledBlock] = []
    @Published var showConflictAlert: Bool = false

    private let service = SchedulerService()
    private let calendar = Calendar.current

    private let taskStore = TaskStore.shared
    private let prefsStore = PreferencesStore.shared

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupBindings()
        refreshSchedule()
    }

    private func setupBindings() {

        let combo1234 = Publishers.CombineLatest4(
            taskStore.$tasks,
            prefsStore.$meals,
            prefsStore.$activities,
            prefsStore.$restActivities
        )

        combo1234
            .combineLatest(prefsStore.$chronotype)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, _ in
                guard let self = self else { return }
                self.refreshSchedule()
                self.refreshNotifications()
            }
            .store(in: &cancellables)
    }


    private func buildUserPreferences() -> UserPreferences {

        let chronotypeString = UserDefaults.standard.string(forKey: "selectedChronotype")
        let chronotype = ChronotypePreference(string: chronotypeString)

        let defaultSleep = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        let defaultWake  = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!

        let sleepTime = UserDefaults.standard.object(forKey: "sleepTime") as? Date ?? defaultSleep
        let wakeTime  = UserDefaults.standard.object(forKey: "wakeTime")  as? Date ?? defaultWake

        let sleepStartComp = calendar.dateComponents([.hour, .minute], from: sleepTime)
        let sleepEndComp   = calendar.dateComponents([.hour, .minute], from: wakeTime)

        let mealPrefs = prefsStore.meals.map { m in
            let comp = calendar.dateComponents([.hour, .minute], from: m.time)
            return DailyMealPref(startTime: comp, durationMinutes: m.duration)
        }

        let recurring = prefsStore.activities.compactMap { act in
            let weekday = weekdayIndex(from: act.day)
            let comp = calendar.dateComponents([.hour, .minute], from: act.time)
            return RecurringBlockPref(
                weekday: weekday,
                startTime: comp,
                durationMinutes: act.durationSeconds > 0
                    ? act.durationSeconds / 60
                    : 60
            )
        }

        var restDates: Set<Date> = []
        for r in prefsStore.restActivities {
            var d = r.startDate.normalized
            let end = r.endDate.normalized
            while d <= end {
                restDates.insert(d)
                d = calendar.date(byAdding: .day, value: 1, to: d)!.normalized
            }
        }

        return UserPreferences(
            chronotype: chronotype,
            sleepStart: sleepStartComp,
            sleepEnd: sleepEndComp,
            meals: mealPrefs,
            recurring: recurring,
            restDates: restDates
        )
    }

    private func weekdayIndex(from day: String) -> Int {
        [
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7
        ][day] ?? 2
    }

    func refreshSchedule() {
        let prefs = buildUserPreferences()

        let blocks = service.schedule(tasks: taskStore.tasks, prefs: prefs)
        self.scheduledBlocks = blocks

        let scheduledIDs = Set(blocks.map { $0.task.id })
        let unscheduled = taskStore.tasks.filter { !scheduledIDs.contains($0.id) }

        var messages: [String] = []

        for task in unscheduled {
            
            let earliest = max(
                Calendar.current.startOfDay(for: Date()),
                task.startDate?.startOfDay ?? Calendar.current.startOfDay(for: Date())
            )
            let deadlineDay = task.deadline.startOfDay
            let lastAllowed = min(deadlineDay, task.endDate?.startOfDay ?? deadlineDay)

            var foundSpace = false
            var foundFreeDayButTooSmall = false
            
            var day = earliest
            while day <= lastAllowed {
                let windows = service.debugWindows(for: day, prefs: buildUserPreferences())
                
                if windows.isEmpty {
                    // fully blocked day
                } else {
                    // Check if ANY window big enough exists
                    let requiredMinutes = max(1, task.durationSeconds / 60)
                    if windows.contains(where: { $0.duration >= requiredMinutes }) {
                        foundSpace = true
                        break
                    } else {
                        foundFreeDayButTooSmall = true
                    }
                }
                day = day.addingDays(1)
            }
            
            if foundSpace == false {
                if foundFreeDayButTooSmall {
                    messages.append("“\(task.name)” is too long — no available time block is long enough.")
                } else {
                    messages.append("“\(task.name)” cannot be scheduled — all days are fully blocked.")
                }
            }
        }

        if !messages.isEmpty {
            self.failedReasonMessages = messages
            self.showFailedAlert = true
        } else {
            self.failedReasonMessages = []
            self.showFailedAlert = false
        }


        let conflicts = service.findViolations(blocks: blocks, prefs: prefs)

        if !conflicts.isEmpty {
            self.conflictBlocks = conflicts
            self.showConflictAlert = true
        } else {
            self.conflictBlocks = []
            self.showConflictAlert = false
        }
    }

    func blocks(for day: Date) -> [ScheduledBlock] {
        let start = Calendar.current.startOfDay(for: day)
        let end   = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        return scheduledBlocks.filter { $0.start >= start && $0.start < end }
    }


    func refreshNotifications() {

        NotificationManager.shared.clearAll()

        let startNotifs = UserDefaults.standard.bool(forKey: "startOfTasks")
        let endNotifs   = UserDefaults.standard.bool(forKey: "endOfTasks")
        let before5     = UserDefaults.standard.bool(forKey: "fiveMinBefTask")

        for block in scheduledBlocks {
            if startNotifs {
                NotificationManager.shared.schedule(
                    id: "\(block.id)-start",
                    title: block.task.name,
                    body: "Your task starts now.",
                    date: block.start
                )
            }
            if endNotifs {
                NotificationManager.shared.schedule(
                    id: "\(block.id)-end",
                    title: block.task.name,
                    body: "Your task ends now.",
                    date: block.end
                )
            }
            if before5 {
                let warnTime = block.start.addingTimeInterval(-300)
                if warnTime > Date() {
                    NotificationManager.shared.schedule(
                        id: "\(block.id)-5min",
                        title: block.task.name,
                        body: "Your task starts in 5 minutes.",
                        date: warnTime
                    )
                }
            }
        }
    }
}

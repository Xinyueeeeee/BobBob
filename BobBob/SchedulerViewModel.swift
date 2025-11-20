

import Foundation
import Combine

final class SchedulerViewModel: ObservableObject {

  
    @Published var scheduledBlocks: [ScheduledBlock] = []
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

        Publishers.CombineLatest4(
            taskStore.$tasks,
            prefsStore.$meals,
            prefsStore.$activities,
            prefsStore.$restActivities
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.refreshSchedule()
            self.refreshNotifications()     // ← auto update notifications
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

        // Meals
        let mealPrefs = prefsStore.meals.map { m in
            let comp = calendar.dateComponents([.hour, .minute], from: m.time)
            return DailyMealPref(startTime: comp, durationMinutes: m.duration)
        }

        // Recurring Activities
        let recurring = prefsStore.activities.compactMap { act in
            let weekday = weekdayIndex(from: act.day)
            let comp = calendar.dateComponents([.hour, .minute], from: act.time)
            return RecurringBlockPref(weekday: weekday, startTime: comp, durationMinutes: 60)
        }

        // Rest Days
        var restDates: Set<Date> = []
        for r in prefsStore.restActivities {
            var d = r.startDate.startOfDay
            let end = r.endDate.startOfDay
            while d <= end {
                restDates.insert(d)
                d = d.addingDays(1)
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
        scheduledBlocks = service.schedule(tasks: taskStore.tasks, prefs: prefs)
    }
    func blocks(for day: Date) -> [ScheduledBlock] {
        let start = day.startOfDay
        let end = start.addingDays(1)
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

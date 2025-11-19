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
            self?.refreshSchedule()
        }
        .store(in: &cancellables)
    }

    private func buildUserPreferences() -> UserPreferences {
        // Chronotype from UserDefaults (AppStorage uses these keys)
        let chronotypeString = UserDefaults.standard.string(forKey: "selectedChronotype")
        let chronotype = ChronotypePreference(string: chronotypeString)

        // Sleep times from UserDefaults
        let defaultSleep = calendar.date(bySettingHour: 23, minute: 0, second: 0, of: Date())!
        let defaultWake  = calendar.date(bySettingHour: 7, minute: 0, second: 0, of: Date())!

        let sleepTime = (UserDefaults.standard.object(forKey: "sleepTime") as? Date) ?? defaultSleep
        let wakeTime  = (UserDefaults.standard.object(forKey: "wakeTime")  as? Date) ?? defaultWake

        let sleepStartComp = calendar.dateComponents([.hour, .minute], from: sleepTime)
        let sleepEndComp   = calendar.dateComponents([.hour, .minute], from: wakeTime)

        // Meals
        let mealPrefs: [DailyMealPref] = prefsStore.meals.map { m in
            let comp = calendar.dateComponents([.hour, .minute], from: m.time)
            return DailyMealPref(startTime: comp, durationMinutes: m.duration)
        }

        // Recurring activities (simplified: only "Weekly" and "Daily" used)
        let recurring: [RecurringBlockPref] = prefsStore.activities.compactMap { act in
            let weekday = weekdayIndex(from: act.day)
            let comp = calendar.dateComponents([.hour, .minute], from: act.time)
            let durationMinutes = 60  // you can tie this to your AddActivitiesView.duration later
            return RecurringBlockPref(weekday: weekday, startTime: comp, durationMinutes: durationMinutes)
        }

        // Rest days (convert ranges to individual dates)
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
        let map = [
            "Sunday": 1,
            "Monday": 2,
            "Tuesday": 3,
            "Wednesday": 4,
            "Thursday": 5,
            "Friday": 6,
            "Saturday": 7
        ]
        return map[day] ?? 2
    }

    func refreshSchedule() {
        let prefs = buildUserPreferences()
        scheduledBlocks = service.schedule(
            tasks: taskStore.tasks,
            prefs: prefs
        )
    }

    func blocks(for day: Date) -> [ScheduledBlock] {
        let start = day.startOfDay
        let end = start.addingDays(1)
        return scheduledBlocks.filter { $0.start >= start && $0.start < end }
    }
}



import Foundation

enum ChronotypePreference {
    case earlyBird
    case nightOwl

    init(string: String?) {
        if string == "Night Owl" { self = .nightOwl }
        else { self = .earlyBird }
    }
}

struct DailyMealPref {
    var startTime: DateComponents
    var durationMinutes: Int
}

struct RecurringBlockPref {
    var weekday: Int
    var startTime: DateComponents
    var durationMinutes: Int
}

struct UserPreferences {
    var chronotype: ChronotypePreference
    var sleepStart: DateComponents
    var sleepEnd: DateComponents
    var meals: [DailyMealPref]
    var recurring: [RecurringBlockPref]
    var restDates: Set<Date>          // absolute full rest days
}

struct ScheduledBlock: Identifiable {
    let id = UUID()
    let task: Task
    let start: Date
    let end: Date
    let isOverdue: Bool
}
final class SchedulerService {

    private let calendar = Calendar.current
    func schedule(tasks: [Task], prefs: UserPreferences, today: Date = Date()) -> [ScheduledBlock] {

        var blocks: [ScheduledBlock] = []
        let sortedTasks = sortTasks(tasks, today: today)

        for task in sortedTasks {

            let earliest = max(
                calendar.startOfDay(for: today),
                task.startDate?.startOfDay ?? calendar.startOfDay(for: today)
            )

            let deadline = task.deadline.startOfDay
            let latestAllowed = min(deadline, task.endDate?.startOfDay ?? deadline)

            var placed: ScheduledBlock?
            var day = earliest
            while day <= latestAllowed {
                if let block = place(task, on: day, prefs: prefs, overdue: false) {
                    placed = block
                    break
                }
                day = day.addingDays(1)
            }
            if placed == nil {
                var od = latestAllowed.addingDays(1)
                let limit = od.addingDays(30)
                while od <= limit {
                    if let block = place(task, on: od, prefs: prefs, overdue: true) {
                        placed = block
                        break
                    }
                    od = od.addingDays(1)
                }
            }

            if let b = placed { blocks.append(b) }
        }

        return blocks
    }

  //sorting

    private func sortTasks(_ tasks: [Task], today: Date) -> [Task] {
        tasks.sorted {
            let p1 = priorityLevel($0, today: today)
            let p2 = priorityLevel($1, today: today)
            if p1 != p2 { return p1 < p2 }

            if $0.deadline != $1.deadline { return $0.deadline < $1.deadline }
            if $0.importance != $1.importance { return $0.importance > $1.importance }

            return $0.durationSeconds < $1.durationSeconds
        }
    }

    private func importanceTier(_ x: Double) -> Int {
        if x >= 0.75 { return 2 }
        if x >= 0.25 { return 1 }
        return 0
    }

    private func isUrgent(_ deadline: Date, today: Date) -> Bool {
        let d1 = calendar.startOfDay(for: today)
        let d2 = calendar.startOfDay(for: deadline)
        let diff = calendar.dateComponents([.day], from: d1, to: d2).day ?? 99
        return diff <= 1
    }

    private func priorityLevel(_ task: Task, today: Date) -> Int {
        let imp = importanceTier(task.importance)
        let urgent = isUrgent(task.deadline, today: today)

        switch (imp, urgent) {
        case (2, true): return 0
        case (1, true): return 1
        case (0, true): return 2
        case (2, false): return 3
        case (1, false): return 4
        case (0, false): return 5
        default: return 5
        }
    }


    private func place(
        _ task: Task,
        on day: Date,
        prefs: UserPreferences,
        overdue: Bool
    ) -> ScheduledBlock? {
//refresh
        var windows = buildDayWindows(for: day, prefs: prefs)
            if windows.isEmpty { return nil }
            let now = Date()
            if calendar.isDate(day, inSameDayAs: now) {
                let cutoff = now
                var adjusted: [TimeWindow] = []
                for w in windows {
                    if w.end <= cutoff { continue }
                    if w.start < cutoff {
                        adjusted.append(TimeWindow(start: cutoff, end: w.end))
                    } else {
                        adjusted.append(w)
                    }
                }
                windows = adjusted
                if windows.isEmpty { return nil }
            }
            let requiredMinutes = max(1, task.durationSeconds / 60)

            for (i, window) in windows.enumerated() where window.duration >= requiredMinutes {

                let start = window.start
                let end = start.adding(minutes: requiredMinutes)
                let remaining = TimeWindow(start: end, end: window.end)
                if remaining.duration > 0 {
                    windows[i] = remaining
                } else {
                    windows.remove(at: i)
                }

                return ScheduledBlock(task: task, start: start, end: end, isOverdue: overdue)
            }

            return nil
    }

//build daily windows

    private func buildDayWindows(for day: Date, prefs: UserPreferences) -> [TimeWindow] {
        let start = day.startOfDay
        let end = start.addingDays(1)
        var windows = [TimeWindow(start: start, end: end)]
        if prefs.restDates.contains(day.startOfDay) {
            return []
        }

        //sleep
        if let s = timeOfDay(prefs.sleepStart, on: day),
           let eRaw = timeOfDay(prefs.sleepEnd, on: day) {

            var e = eRaw
            if e <= s { e = e.addingDays(1) }

            subtract(TimeWindow(start: s, end: e), from: &windows)
        }

        // meals
        for m in prefs.meals {
            if let s = timeOfDay(m.startTime, on: day) {
                subtract(TimeWindow(start: s, end: s.adding(minutes: m.durationMinutes)), from: &windows)
            }
        }

        //recurring
        let weekday = calendar.component(.weekday, from: day)
        for r in prefs.recurring where r.weekday == weekday {
            if let s = timeOfDay(r.startTime, on: day) {
                subtract(TimeWindow(start: s, end: s.adding(minutes: r.durationMinutes)), from: &windows)
            }
        }

            //chronotype
        let focusBlocks = chronotypeWindows(for: day, prefs: prefs)
        let result = intersect(windows, focusBlocks)

        return result.filter { $0.duration > 0 }
    }

//chronotype windows

    private func chronotypeWindows(for day: Date, prefs: UserPreferences) -> [TimeWindow] {
        switch prefs.chronotype {
        case .earlyBird:
            return [
                TimeWindow(start: day.at(7, 0), end: day.at(11, 0)),
                TimeWindow(start: day.at(13, 0), end: day.at(17, 0))
            ]
        case .nightOwl:
            return [
                TimeWindow(start: day.at(14, 0), end: day.at(18, 0)),
                TimeWindow(start: day.at(20, 0), end: day.at(23, 0))
            ]
        }
    }

//window math

    private struct TimeWindow {
        var start: Date
        var end: Date
        var duration: Int { max(0, Int(end.timeIntervalSince(start) / 60)) }
    }

    private func subtract(_ block: TimeWindow, from windows: inout [TimeWindow]) {
        var result: [TimeWindow] = []

        for w in windows {
            if block.end <= w.start || block.start >= w.end {
                result.append(w)
                continue
            }

            if block.start <= w.start && block.end >= w.end {
                continue
            }

            if block.start > w.start && block.end >= w.end {
                let left = TimeWindow(start: w.start, end: block.start)
                if left.duration > 0 { result.append(left) }
                continue
            }

            if block.start <= w.start && block.end < w.end {
                let right = TimeWindow(start: block.end, end: w.end)
                if right.duration > 0 { result.append(right) }
                continue
            }

            if block.start > w.start && block.end < w.end {
                let left = TimeWindow(start: w.start, end: block.start)
                let right = TimeWindow(start: block.end, end: w.end)
                if left.duration > 0 { result.append(left) }
                if right.duration > 0 { result.append(right) }
                continue
            }
        }

        windows = result
    }

    private func intersect(_ base: [TimeWindow], _ focus: [TimeWindow]) -> [TimeWindow] {
        var result: [TimeWindow] = []

        for w in base {
            for f in focus {
                let s = max(w.start, f.start)
                let e = min(w.end, f.end)
                if e > s { result.append(TimeWindow(start: s, end: e)) }
            }
        }

        return result
    }
//utilities

    private func timeOfDay(_ comp: DateComponents, on day: Date) -> Date? {
        var c = calendar.dateComponents([.year, .month, .day], from: day)
        c.hour = comp.hour
        c.minute = comp.minute
        return calendar.date(from: c)
    }
}

import Foundation
import SwiftUI

enum ChronotypePreference {
    case earlyBird
    case nightOwl

    init(string: String?) {
        if string == "Night Owl" {
            self = .nightOwl
        } else {
            self = .earlyBird
        }
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
    var restDates: Set<Date>
}

struct ScheduledBlock: Identifiable {
    let id = UUID()
    let task: Task
    let start: Date
    let end: Date
    let isOverdue: Bool
}

extension Date {
    var normalized: Date { Calendar.current.startOfDay(for: self) }
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }

    func addingDays(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

    func adding(minutes: Int) -> Date {
        self.addingTimeInterval(TimeInterval(minutes * 60))
    }

    func at(_ hour: Int, _ minute: Int) -> Date {
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: self)
        comps.hour = hour
        comps.minute = minute
        return Calendar.current.date(from: comps)!
    }
}

final class SchedulerService {

    private let calendar = Calendar.current

    struct TimeWindow {
        var start: Date
        var end: Date
        var duration: Int { max(0, Int(end.timeIntervalSince(start) / 60)) }
    }

    func debugWindows(for day: Date, prefs: UserPreferences) -> [TimeWindow] {
        return buildDayWindows(for: day, prefs: prefs)
    }
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
        case (2, true):  return 0
        case (1, true):  return 1
        case (0, true):  return 2
        case (2, false): return 3
        case (1, false): return 4
        case (0, false): return 5
        default:         return 5
        }
    }


    func schedule(
        tasks: [Task],
        prefs: UserPreferences,
        today: Date = Date()
    ) -> [ScheduledBlock] {

        var blocks: [ScheduledBlock] = []
        let sortedTasks = sortTasks(tasks, today: today)

        for task in sortedTasks {

            let earliest = max(
                calendar.startOfDay(for: today),
                task.startDate?.startOfDay ?? calendar.startOfDay(for: today)
            )

            let deadlineMoment = task.deadline

            let latestAllowed = min(
                deadlineMoment,
                task.endDate ?? deadlineMoment
            )

            var placed: ScheduledBlock? = nil
            var day = earliest

            while day <= latestAllowed {
                if let block = place(task, on: day, prefs: prefs, scheduledBlocks: blocks, overdue: false) {
                    placed = block
                    break
                }
                day = day.addingDays(1)
            }

          if placed == nil {
                var od = latestAllowed.addingTimeInterval(60)
                let limit = od.addingDays(30)
                while od <= limit {
                    if let block = place(task, on: od, prefs: prefs, scheduledBlocks: blocks, overdue: true) {
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

    func findViolations(blocks: [ScheduledBlock], prefs: UserPreferences) -> [ScheduledBlock] {

        blocks.filter { block in
            let day = block.start.startOfDay

            if prefs.restDates.contains(day.normalized) {
                return true
            }

            if let sleepStartOnDay = timeOfDay(prefs.sleepStart, on: day),
               let sleepEndOnDay = timeOfDay(prefs.sleepEnd, on: day) {

                if crossesMidnight(start: prefs.sleepStart, end: prefs.sleepEnd) {

                    let earlyStart = day.startOfDay
                    let earlyEnd = sleepEndOnDay

                    let lateStart = sleepStartOnDay
                    let lateEnd = day.addingDays(1).startOfDay

                    if intervalsOverlap(start1: block.start, end1: block.end, start2: earlyStart, end2: earlyEnd)
                        || intervalsOverlap(start1: block.start, end1: block.end, start2: lateStart, end2: lateEnd) {
                        return true
                    }

                } else {
                    if intervalsOverlap(start1: block.start, end1: block.end, start2: sleepStartOnDay, end2: sleepEndOnDay) {
                        return true
                    }
                }
            }

            for m in prefs.meals {
                if let s = timeOfDay(m.startTime, on: day) {
                    let e = s.adding(minutes: m.durationMinutes)
                    if intervalsOverlap(start1: block.start, end1: block.end, start2: s, end2: e) {
                        return true
                    }
                }
            }

            let weekday = calendar.component(.weekday, from: day)
            for r in prefs.recurring where r.weekday == weekday {
                if let s = timeOfDay(r.startTime, on: day) {
                    let e = s.adding(minutes: r.durationMinutes)
                    if intervalsOverlap(start1: block.start, end1: block.end, start2: s, end2: e) {
                        return true
                    }
                }
            }

            return false
        }
    }

    private func place(
        _ task: Task,
        on day: Date,
        prefs: UserPreferences,
        scheduledBlocks: [ScheduledBlock],
        overdue: Bool
    ) -> ScheduledBlock? {

        var windows = buildDayWindows(for: day, prefs: prefs)

        for b in scheduledBlocks where calendar.isDate(b.start, inSameDayAs: day) {
            subtract(TimeWindow(start: b.start, end: b.end), from: &windows)
        }

        if windows.isEmpty { return nil }

        let now = Date()
        if calendar.isDate(day, inSameDayAs: now) {
            windows = windows.compactMap { w in
                if w.end <= now { return nil }
                return TimeWindow(start: max(w.start, now), end: w.end)
            }
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

            let overdueFlag = start > task.deadline
            return ScheduledBlock(task: task, start: start, end: end, isOverdue: overdueFlag)

        }

        return nil
    }

    private func buildDayWindows(for day: Date, prefs: UserPreferences) -> [TimeWindow] {

        if prefs.restDates.contains(day.normalized) {
            return []
        }

        let startOfDay = day.startOfDay
        let endOfDay = startOfDay.addingDays(1)
        var windows = [TimeWindow(start: startOfDay, end: endOfDay)]

        if let sleepStartOnDay = timeOfDay(prefs.sleepStart, on: day),
           let sleepEndOnDay = timeOfDay(prefs.sleepEnd, on: day) {

            if crossesMidnight(start: prefs.sleepStart, end: prefs.sleepEnd) {

                subtract(TimeWindow(start: startOfDay, end: sleepEndOnDay), from: &windows)
                subtract(TimeWindow(start: sleepStartOnDay, end: endOfDay), from: &windows)

            } else {

                subtract(TimeWindow(start: sleepStartOnDay, end: sleepEndOnDay), from: &windows)
            }
        }

        for m in prefs.meals {
            if let s = timeOfDay(m.startTime, on: day) {
                subtract(
                    TimeWindow(start: s, end: s.adding(minutes: m.durationMinutes)),
                    from: &windows
                )
            }
        }

        let weekday = calendar.component(.weekday, from: day)
        for r in prefs.recurring where r.weekday == weekday {
            if let s = timeOfDay(r.startTime, on: day) {
                subtract(
                    TimeWindow(start: s, end: s.adding(minutes: r.durationMinutes)),
                    from: &windows
                )
            }
        }

        let blocks = chronotypeWindows(for: day, prefs: prefs)
        let result = intersect(windows, blocks)

        return result.filter { $0.duration > 0 }
    }

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
                if e > s {
                    result.append(TimeWindow(start: s, end: e))
                }
            }
        }

        return result
    }

    private func timeOfDay(_ comp: DateComponents, on day: Date) -> Date? {
        var c = calendar.dateComponents([.year, .month, .day], from: day)
        c.hour = comp.hour
        c.minute = comp.minute
        return calendar.date(from: c)
    }

    private func intervalsOverlap(
        start1: Date, end1: Date,
        start2: Date, end2: Date
    ) -> Bool {
        return max(start1, start2) < min(end1, end2)
    }

    private func crossesMidnight(start: DateComponents, end: DateComponents) -> Bool {
        let sh = start.hour ?? 0
        let sm = start.minute ?? 0
        let eh = end.hour ?? 0
        let em = end.minute ?? 0
        if eh > sh { return false }
        if eh < sh { return true }
        return em <= sm
    }
}

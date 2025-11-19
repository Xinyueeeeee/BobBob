//
//  SchedulerService.swift
//  BobBob
//
//  Created by Hanyi on 19/11/25.
//

import Foundation

// ======================================================
// MARK: - YOUR APP MODELS (from real code you provided)
// ======================================================


// ======================================================
// MARK: - INTERNAL PREFS MODELS FOR SCHEDULER
// ======================================================

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

    /// absolute rest days (full-day no work)
    var restDates: Set<Date>
}

// ======================================================
// MARK: - OUTPUT MODEL
// ======================================================

struct ScheduledBlock: Identifiable {
    let id = UUID()
    let task: Task
    let start: Date
    let end: Date
    let isOverdue: Bool
}

// ======================================================
// MARK: - SCHEDULER SERVICE
// ======================================================

final class SchedulerService {

    private let calendar = Calendar.current

    // ======================================================
    // MARK: PUBLIC ENTRY POINT
    // ======================================================

    func schedule(tasks: [Task], prefs: UserPreferences, today: Date = Date()) -> [ScheduledBlock] {
        var blocks: [ScheduledBlock] = []
        let sortedTasks = sortTasks(tasks, today: today)

        /// Caches day windows after subtracting sleep/meals/activities/etc.
        var windowsCache: [Date: [TimeWindow]] = [:]

        for task in sortedTasks {

            let earliest = max(
                calendar.startOfDay(for: today),
                task.startDate?.startOfDay ?? calendar.startOfDay(for: today)
            )

            let deadline = task.deadline.startOfDay
            let latestAllowed = min(deadline, task.endDate?.startOfDay ?? deadline)

            var placed: ScheduledBlock?

            // PASS 1 — try before deadline
            var day = earliest
            while day <= latestAllowed {

                if let block = place(task, on: day, windowsCache: &windowsCache, prefs: prefs, overdue: false) {
                    placed = block
                    break
                }
                day = day.addingDays(1)
            }

            // PASS 2 — overdue placement
            if placed == nil {
                var overdueDay = latestAllowed.addingDays(1)
                let limit = overdueDay.addingDays(30)

                while overdueDay <= limit {
                    if let block = place(task, on: overdueDay, windowsCache: &windowsCache, prefs: prefs, overdue: true) {
                        placed = block
                        break
                    }
                    overdueDay = overdueDay.addingDays(1)
                }
            }

            if let b = placed { blocks.append(b) }
        }

        return blocks
    }

    // ======================================================
    // MARK: SORTING (6-TIER PRIORITY)
    // ======================================================

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

    /// convert your slider to 0/1/2 tier
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

    // ======================================================
    // MARK: FITTING TASK INTO WINDOWS FOR A GIVEN DAY
    // ======================================================

    private func place(
        _ task: Task,
        on day: Date,
        windowsCache: inout [Date: [TimeWindow]],
        prefs: UserPreferences,
        overdue: Bool
    ) -> ScheduledBlock? {

        let key = day.startOfDay
        let windows = windowsCache[key] ?? buildDayWindows(for: day, prefs: prefs)
        if windows.isEmpty {
            windowsCache[key] = windows
            return nil
        }

        let required = max(1, task.durationSeconds / 60)

        for (i, window) in windows.enumerated() {
            if window.duration >= required {

                let start = window.start
                let end = start.adding(minutes: required)

                // shrink window
                let remaining = TimeWindow(start: end, end: window.end)

                var updated = windows
                if remaining.duration > 0 {
                    updated[i] = remaining
                } else {
                    updated.remove(at: i)
                }

                windowsCache[key] = updated

                return ScheduledBlock(task: task, start: start, end: end, isOverdue: overdue)
            }
        }

        windowsCache[key] = windows
        return nil
    }

    // ======================================================
    // MARK: BUILD DAILY WINDOWS (sleep, meals, recurring, rest, chronotype)
    // ======================================================

    private func buildDayWindows(for day: Date, prefs: UserPreferences) -> [TimeWindow] {

        // FULL DAY
        let start = day.startOfDay
        let end = start.addingDays(1)
        var windows = [TimeWindow(start: start, end: end)]

        // ABSOLUTE REST DAY?
        if prefs.restDates.contains(day.startOfDay) { return [] }

        // SLEEP
        if let s = timeOfDay(prefs.sleepStart, on: day),
           let eRaw = timeOfDay(prefs.sleepEnd, on: day) {

            var e = eRaw
            if e <= s { e = e.addingDays(1) }    // crosses midnight

            subtract(TimeWindow(start: s, end: e), from: &windows)
        }

        // MEALS
        for m in prefs.meals {
            if let s = timeOfDay(m.startTime, on: day) {
                let e = s.adding(minutes: m.durationMinutes)
                subtract(TimeWindow(start: s, end: e), from: &windows)
            }
        }

        // RECURRING ACTIVITIES
        let weekday = calendar.component(.weekday, from: day)
        for r in prefs.recurring where r.weekday == weekday {
            if let s = timeOfDay(r.startTime, on: day) {
                let e = s.adding(minutes: r.durationMinutes)
                subtract(TimeWindow(start: s, end: e), from: &windows)
            }
        }

        // CHRONOTYPE FOCUS WINDOWS
        let focus = chronotypeWindows(for: day, prefs: prefs)
        let intersected = intersect(windows, focus)

        return intersected.filter { $0.duration > 0 }
    }

    // ======================================================
    // MARK: CHRONOTYPE WINDOWS
    // ======================================================

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

    // ======================================================
    // MARK: WINDOW MATH
    // ======================================================

    private struct TimeWindow {
        var start: Date
        var end: Date
        var duration: Int { max(0, Int(end.timeIntervalSince(start) / 60)) }
    }

    private func subtract(_ block: TimeWindow, from windows: inout [TimeWindow]) {
        var result: [TimeWindow] = []

        for w in windows {
            // no overlap
            if block.end <= w.start || block.start >= w.end {
                result.append(w)
                continue
            }

            // full cover
            if block.start <= w.start && block.end >= w.end {
                continue
            }

            // cutoff start
            if block.start > w.start && block.end >= w.end {
                let left = TimeWindow(start: w.start, end: block.start)
                if left.duration > 0 { result.append(left) }
                continue
            }

            // cutoff end
            if block.start <= w.start && block.end < w.end {
                let right = TimeWindow(start: block.end, end: w.end)
                if right.duration > 0 { result.append(right) }
                continue
            }

            // middle split
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

    // ======================================================
    // MARK: UTILITIES
    // ======================================================

    private func timeOfDay(_ comp: DateComponents, on day: Date) -> Date? {
        var c = calendar.dateComponents([.year, .month, .day], from: day)
        c.hour = comp.hour
        c.minute = comp.minute
        return calendar.date(from: c)
    }
}


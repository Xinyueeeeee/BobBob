import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
}

struct CalendarView: View {

    @State private var currentDate = Date()
    @State private var days: [CalendarDay] = []
    @State private var path: [Date] = []

    @EnvironmentObject var scheduleVM: SchedulerViewModel
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var preferenceStore: PreferencesStore

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.blue.opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Spacer().frame(height: 80)

                    HStack {
                        Button { changeMonth(-1) } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }

                        Spacer()

                        Text(monthTitle(currentDate))
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.black)

                        Spacer()

                        Button { changeMonth(1) } label: {
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        HStack {
                            ForEach(weekdaySymbols(), id: \.self) { day in
                                Text(day)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity)
                            }
                        }

                        LazyVGrid(columns: columns, spacing: 18) {
                            ForEach(days) { day in
                                if monthInt(for: day.date) != monthInt(for: currentDate) {
                                    Text("").frame(height: 45)
                                } else {
                                    NavigationLink(value: day.date) {
                                        let isRestDay = preferenceStore.restActivities.contains(where: { activity in
                                            let start = activity.startDate.normalized
                                            let end = activity.endDate.normalized
                                            return day.date.normalized >= start && day.date.normalized <= end
                                        })

                                        ZStack {
                                            if isRestDay {
                                                Circle()
                                                    .stroke(Color.blue, lineWidth: 2)
                                                    .frame(width: 38, height: 38)
                                                    .offset(y: -5.5)
                                            }

                                            VStack(spacing: 4) {
                                                Text("\(dayInt(for: day.date))")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.black)
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 6, height: 6)
                                                    .opacity(scheduleVM.blocks(for: day.date).isEmpty ? 0 : 1)                                            }
                                        }
                                        .frame(maxWidth: .infinity, minHeight: 45)

                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 8)
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .onAppear { rebuildDays() }
            .navigationDestination(for: Date.self) { date in
                DayDetailView(day: date)
                    .environmentObject(scheduleVM)
                    .environmentObject(taskStore)
                    .environmentObject(preferenceStore)
            }
            .alert("Some tasks could not be scheduled", isPresented: $scheduleVM.showFailedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(scheduleVM.failedReasonMessages, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.black)
                    }
                }
            }
            .alert("Some tasks overlap with your schedule", isPresented: $scheduleVM.showConflictAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                VStack(alignment: .leading, spacing: 6) {
                    Text("These tasks overlap with:")
                    Text("Meals")
                    Text("Recurring activities")
                    Text("Rest days")
                    Text("Sleep schedule")
                        .padding(.bottom, 8)

                    ForEach(scheduleVM.conflictBlocks) { block in
                        Text(" \(block.task.name)")
                            .fontWeight(.semibold)
                    }
                }
            }
        }
    }

    private func weekdaySymbols() -> [String] {
        Calendar.current.shortWeekdaySymbols.map { $0.capitalized }
    }

    private func monthTitle(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: date)
    }

    private func monthInt(for date: Date) -> Int {
        Calendar.current.component(.month, from: date)
    }

    private func dayInt(for date: Date) -> Int {
        Calendar.current.component(.day, from: date)
    }

    private func changeMonth(_ value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
            rebuildDays()
        }
    }

    private func rebuildDays() {
        let start = calendarDisplayDays(for: currentDate)
        days = start.map { CalendarDay(date: $0) }
    }

    private func startOfMonth(_ date: Date) -> Date {
        Calendar.current.dateInterval(of: .month, for: date)!.start
    }

    private func endOfMonth(_ date: Date) -> Date {
        let end = Calendar.current.dateInterval(of: .month, for: date)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: end)!
    }

    private func numberOfDaysInMonth(_ date: Date) -> Int {
        Calendar.current.component(.day, from: endOfMonth(date))
    }

    private func firstWeekdayBeforeStart(of date: Date) -> Date {
        let start = startOfMonth(date)
        let weekday = Calendar.current.component(.weekday, from: start)
        let firstWeekday = Calendar.current.firstWeekday

        var diff = weekday - firstWeekday
        if diff < 0 { diff += 7 }

        return Calendar.current.date(byAdding: .day, value: -diff, to: start)!
    }

    private func calendarDisplayDays(for date: Date) -> [Date] {
        var result: [Date] = []
        let first = firstWeekdayBeforeStart(of: date)
        let start = startOfMonth(date)
        let total = numberOfDaysInMonth(date)

        var d = first
        while d < start {
            result.append(d)
            d = Calendar.current.date(byAdding: .day, value: 1, to: d)!
        }

        for offset in 0..<total {
            let newDay = Calendar.current.date(byAdding: .day, value: offset, to: start)!
            result.append(newDay)
        }

        return result
    }
}

struct DayDetailView: View {

    @EnvironmentObject var scheduleVM: SchedulerViewModel
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var preferenceStore: PreferencesStore

    let day: Date

    var isRestDay: Bool {
        preferenceStore.restActivities.contains { activity in
            let s = activity.startDate.normalized
            let e = activity.endDate.normalized
            return day.normalized >= s && day.normalized <= e
        }
    }
    func weekdayIndex(from day: String) -> Int {
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


    var body: some View {

        let blocks = (scheduleVM.blocks(for: day) + dailyFixedBlocks(for: day))
            .sorted { $0.start < $1.start }

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                VStack(alignment: .leading, spacing: 4) {
                    Text(day, format: .dateTime.weekday(.wide))
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)

                    Text(day, format: .dateTime.day().month().year())
                        .font(.title2)
                        .foregroundColor(.black.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                
                if isRestDay {
                    VStack(spacing: 10) {
                        Text("Rest Day")
                            .font(.title)
                            .bold()
                            .foregroundColor(.blue)

                        Text("You have marked today as a rest day.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                } else if blocks.isEmpty {
                    ContentUnavailableView(
                        "Nothing Scheduled",
                        systemImage: "calendar.badge.exclamationmark",
                        description: Text("You have no tasks or activities today.")
                    )
                    .padding(.top, 20)

                } else {
                    VStack(spacing: 12) {
                        ForEach(blocks) { block in
                            NavigationLink {
                                TaskDetailView(item: block.task)
                            } label: {
                                TaskBlockView(block: block)
                                    .environmentObject(taskStore)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }

    private func dailyFixedBlocks(for day: Date) -> [ScheduledBlock] {
        var result: [ScheduledBlock] = []
        let calendar = Calendar.current
        for meal in preferenceStore.meals {
            let comps = calendar.dateComponents([.hour, .minute], from: meal.time)

            if let hour = comps.hour, let minute = comps.minute {
                let start = calendar.date(bySettingHour: hour,
                                          minute: minute,
                                          second: 0,
                                          of: day)!

                let end = start.addingTimeInterval(TimeInterval(meal.duration * 60))

                let pseudoTask = Task(
                    id: UUID(),
                    name: meal.mealType,
                    deadline: day,
                    durationSeconds: meal.duration * 60,
                    importance: 0,
                    startDate: start,
                    endDate: end,
                    isCompleted: false
                )

                result.append(ScheduledBlock(task: pseudoTask, start: start, end: end, isOverdue: false))
            }
        }

        let weekday = calendar.component(.weekday, from: day)

        for act in preferenceStore.activities
            where weekdayIndex(from: act.day) == weekday {

            let comps = calendar.dateComponents([.hour, .minute], from: act.time)

            if let hour = comps.hour, let minute = comps.minute {
                let start = calendar.date(bySettingHour: hour,
                                          minute: minute,
                                          second: 0,
                                          of: day)!

                let end = start.addingTimeInterval(TimeInterval(act.durationSeconds))

                let pseudoTask = Task(
                    id: UUID(),
                    name: act.name,
                    deadline: day,
                    durationSeconds: act.durationSeconds,
                    importance: 0,
                    startDate: start,
                    endDate: end,
                    isCompleted: false
                )

                result.append(ScheduledBlock(task: pseudoTask, start: start, end: end, isOverdue: false))
            }
        }


        return result.sorted { $0.start < $1.start }
    }


}

struct TaskBlockView: View {
    @EnvironmentObject var taskStore: TaskStore
    let block: ScheduledBlock

    var isFixedBlock: Bool {
        block.task.importance == 0 &&
        block.task.startDate != nil &&
        block.task.id != block.task.id
    }

    var isMealOrActivity: Bool {
        block.task.importance == 0 &&
        (block.task.name.lowercased().contains("meal") ||
         block.task.name.lowercased().contains("lunch") ||
         block.task.name.lowercased().contains("breakfast") ||
         block.task.name.lowercased().contains("dinner") ||
         block.task.name.lowercased().contains("gym") ||
         block.task.name.lowercased().contains("run") ||
         block.task.name.lowercased().contains("activity"))
    }

    var body: some View {

        HStack(spacing: 12) {

            if !isMealOrActivity {
                Button { toggleCompletion() } label: {
                    ReminderCircle(isCompleted: block.task.isCompleted)
                }
                .buttonStyle(.plain)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(block.task.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .opacity(block.task.isCompleted ? 0.5 : 1)

                Text("\(time(block.start)) – \(time(block.end))")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))

                if block.isOverdue && !isMealOrActivity {
                    Text("Task has been scheduled after its deadline")
                        .font(.caption)
                }
            }

            Spacer()
        }
        .padding()
        .background(isMealOrActivity ? Color.blue.opacity(0.15) : Color.blue.opacity(0.4))
        .cornerRadius(12)
        .padding(.vertical, 4)
    }

    private func toggleCompletion() {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == block.task.id }) {
            taskStore.tasks[index].isCompleted.toggle()
        }
    }

    private func time(_ date: Date) -> String {
        let f = DateFormatter()
        f.timeStyle = .short
        return f.string(from: date)
    }
}


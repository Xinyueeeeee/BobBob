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
                        Text((monthTitle)(currentDate))
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal)

                    HStack {
                        Button { changeMonth(-1) } label: {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
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
                                        VStack(spacing: 4) {
                                            Text("\(dayInt(for: day.date))")
                                                .font(.system(size: 20))
                                                .foregroundColor(.black)

                                            if scheduleVM.blocks(for: day.date).count > 0 {
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 6, height: 6)
                                            }
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
            .alert("This task could not be scheduled", isPresented: $scheduleVM.showFailedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                VStack(alignment: .leading) {
                    ForEach(scheduleVM.failedTasks) { t in
                        Text(" \(t.name)")
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

    var body: some View {
        let blocks = scheduleVM.blocks(for: day)

        ScrollView {
            VStack(alignment: .leading) {
                Text(day, format: .dateTime.weekday(.wide))
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                Text(day, format: .dateTime.day().month().year())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
            
                if blocks.isEmpty {
                    VStack(spacing: 10) {
                        Text("No tasks scheduled")
                            .foregroundColor(.black.opacity(0.6))
                            .font(.headline)
                        Text("Add tasks and your algorithm will schedule them here.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                } else {
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

                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Schedule")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func formattedDay(_ date: Date) -> String {
        date.formatted(.dateTime.weekday(.wide).day().month().year())
    }
}


struct TaskBlockView: View {
    @EnvironmentObject var taskStore: TaskStore
    let block: ScheduledBlock

    var body: some View {
        HStack(spacing: 12) {
            Button {
                toggleCompletion()
            } label: {
                ReminderCircle(isCompleted: block.task.isCompleted)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(block.task.name)
                    .font(.headline)
                    .foregroundColor(.black)
                    .opacity(block.task.isCompleted ? 0.5 : 1)

                Text("\(time(block.start)) – \(time(block.end))")
                    .font(.subheadline)
                    .foregroundColor(.black.opacity(0.7))


                if block.isOverdue {
                    Text("⚠ Overdue placement")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
            Spacer()
        }
        .padding()
        .background(block.task.isCompleted ? Color.gray.opacity(0.2) :Color.blue.opacity(0.4))
        .cornerRadius(12)
        .padding(.horizontal)
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


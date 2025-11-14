import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
}

struct CalendarView: View {

    @State private var color: Color = .blue
    @State private var currentDate = Date.now

    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    @State private var days: [CalendarDay] = []
    @State private var selectedDay: CalendarDay? = nil

    var body: some View {
        VStack(spacing: 20) {

            LabeledContent("Calendar Color") {
                ColorPicker("", selection: $color, supportsOpacity: false)
            }

            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }

                Spacer()

                Text(currentDate.formatted(.dateTime.year().month(.wide)))
                    .font(.title2)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: columns) {
                ForEach(days) { day in
                    if day.date.monthInt != currentDate.monthInt {
                        Text("")
                    } else {
                        Button {
                            selectedDay = day
                        } label: {
                            Text(day.date.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(
                                    Circle()
                                        .foregroundStyle(color.opacity(0.3))
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .onAppear { updateDays() }
        .sheet(item: $selectedDay) { day in
            DayDetailView(day: day.date)
        }
    }

    private func updateDays() {
        let firstOfMonth = currentDate.startOfMonth
        days = firstOfMonth.calendarDisplayDays.map { CalendarDay(date: $0) }
    }

    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
            updateDays()
        }
    }
}

#Preview {
    CalendarView()
}

struct DayDetailView: View {
    let day: Date

    var body: some View {
        VStack(spacing: 20) {
            Text("Selected Day")
                .font(.largeTitle)
            Text(day.formatted(date: .complete, time: .omitted))
                .font(.title2)
            Spacer()
        }
        .padding()
    }
}


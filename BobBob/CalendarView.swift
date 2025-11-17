import SwiftUI

struct CalendarDay: Identifiable {
    let id = UUID()
    let date: Date
}

struct CalendarView: View {
    @State private var currentDate = Date()
    @State private var days: [CalendarDay] = []
    @State private var path: [Date] = []
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Spacer().frame(height: 80)
                    
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text(monthTitle(currentDate))
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
                    }
                    
                    // White box with weekdays and grid
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
                                        Text("\(dayInt(for: day.date))")
                                            .font(.system(size: 20))
                                            .foregroundColor(.black)
                                            .frame(maxWidth: .infinity, minHeight: 45)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .onAppear { rebuildDays() }
            .navigationDestination(for: Date.self) { day in
                DayDetailView(day: day)
            }
        }
    }
    
    private func weekdaySymbols() -> [String] {
        let symbols = Calendar.current.shortWeekdaySymbols
        return symbols.map { $0.capitalized }
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
    
    private func rebuildDays() {
        days = calendarDisplayDays(for: currentDate).map { CalendarDay(date: $0) }
    }
    
    private func changeMonth(_ value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
            rebuildDays()
        }
    }
}

struct DayDetailView: View {
    let day: Date
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Text(formattedDay(day))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top)
                    
                    ForEach(0..<24) { hour in
                        HStack(spacing: 10) {
                            Text(String(format: "%02d:00", hour))
                                .frame(width: 50, alignment: .trailing)
                                .foregroundColor(.black)
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(height: 0.5)
                        }
                        .frame(height: 60)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    private func formattedDay(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM d"
        return f.string(from: date)
    }
}



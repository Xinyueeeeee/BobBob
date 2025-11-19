
import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    var body: some View {
        NavigationStack {
            IntroductionCarouselView(hasSeenOnboarding: $hasSeenOnboarding)
        }
    }
}

struct IntroductionCarouselView: View {
    @State private var index = 0
    @Binding var hasSeenOnboarding: Bool

    var body: some View {

        ZStack {
                LinearGradient(
                                colors: [
                                    Color(red: 10/255, green: 25/255, blue: 47/255),
                                    Color(red: 25/255, green: 60/255, blue: 120/255)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()



            TabView(selection: $index) {
                IntroductionScreenView1(hasSeenOnboarding: $hasSeenOnboarding)
                    .tag(0)
                IntroductionScreenView2(hasSeenOnboarding: $hasSeenOnboarding)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

struct IntroductionScreenView1: View {
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Welcome")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                Text("to a task organiser that adapts to the way you actually work")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding()
        }
    }
}

struct IntroductionScreenView2: View {
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        VStack {
            Spacer()
            Text("Discover")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            Text("your working style")
                .padding(.bottom, 40)
                .foregroundColor(.gray)
            Spacer()
            NavigationLink {
                ChronotypeView(hasSeenOnboarding: $hasSeenOnboarding)
            } label: {
                Text("Let's get started!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 180/255, green: 220/255, blue: 255/255))
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                    .foregroundColor(Color(red: 45/255, green: 90/255, blue: 150/255))
            }
            .padding(.horizontal)
            .padding(.bottom, 80)
        }
        .padding()
    }
}

struct HabitualStyleView: View {
    @State private var selectedStyle: String? = nil
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack(spacing: 30) {
                Text("What is your habitual style?")
                    .font(.title3)
                    .bold()
                    .padding(.top)

                    .foregroundColor(.gray.opacity(0.5))

                Button {
                    selectedStyle = "Hopper"
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hopper")
                            .font(.headline)
                            .foregroundColor(selectedStyle == "Hopper" ? .white : .black)
                        Text("Someone who usually focuses for short bursts of time and prefers breaking activities into multiple sessions.")
                            .font(.subheadline)
                            .foregroundColor(selectedStyle == "Hopper" ? .white.opacity(0.9) : .black.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedStyle == "Hopper" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)
                Button {
                    selectedStyle = "Hyperfocus"
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Hyperfocus")
                            .font(.headline)
                            .foregroundColor(selectedStyle == "Hyperfocus" ? .white : .black)
                        Text("Someone who prefers focusing for longer periods of time and can finish tasks in a single session.")
                            .font(.subheadline)
                            .foregroundColor(selectedStyle == "Hyperfocus" ? .white.opacity(0.9) : .black.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedStyle == "Hyperfocus" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)
                Spacer()
                Text("Different people have different working styles.")
                    .font(.footnote)

                    .foregroundColor(.gray.opacity(0.5))
                NavigationLink {
                    ChronotypeView(hasSeenOnboarding: $hasSeenOnboarding)
                } label: {

                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(selectedStyle == nil ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedStyle == nil)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .navigationTitle("Habitual Style")
        }
    }
}

struct ChronotypeView: View {
    @AppStorage("selectedChronotype") private var selectedChronotype: String?
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Text("What is your chronotype?")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.black.opacity(0.5))

                    .foregroundColor(.gray.opacity(8.0))
                Button {
                    selectedChronotype = "Early Bird"
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Early Bird")
                            .font(.headline)
                            .foregroundColor(selectedChronotype == "Early Bird" ? .white : .black)

                        Text("You prefer starting your day earlier and feel most productive in the morning.")
                            .font(.subheadline)
                            .foregroundColor(selectedChronotype == "Early Bird" ? .white.opacity(0.9) : .black.opacity(0.7))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedChronotype == "Early Bird" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)

                // Night Owl
                Button {
                    selectedChronotype = "Night Owl"
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Night Owl")
                            .font(.headline)
                            .foregroundColor(selectedChronotype == "Night Owl" ? .white : .black)

                        Text("You focus better later in the day and prefer working at night.")
                            .font(.subheadline)
                            .foregroundColor(selectedChronotype == "Night Owl" ? .white.opacity(0.9) : .black.opacity(0.7))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedChronotype == "Night Owl" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)

                Spacer()
                Text("Different people prefer working at different time periods.")
                    .font(.footnote)
                    .foregroundColor(.black.opacity(0.5))

                    .foregroundColor(.gray.opacity(8.0))
                NavigationLink {
                    NapTimeView(hasSeenOnboarding: $hasSeenOnboarding)
                } label: {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(selectedChronotype == nil ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .disabled(selectedChronotype == nil)
                .padding()
            }
            .navigationTitle("Chronotype")
        }
    }
}

struct NapTimeView: View {
    @AppStorage("sleepTime") private var sleepTime: Date = Date()
    @AppStorage("wakeTime") private var wakeTime: Date = Date()
    @Binding var hasSeenOnboarding: Bool
    @AppStorage("sleepTime") private var sleepTime = Calendar.current.date(
        bySettingHour: 22, minute: 0, second: 0, of: Date()
    )!
    
    @AppStorage("wakeTime") private var wakeTime = Calendar.current.date(
        bySettingHour: 6, minute: 0, second: 0, of: Date()
    )!


    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            VStack {
                Text("What time do you go to sleep?")
                    .font(.headline)

                    .foregroundColor(.gray.opacity(0.8))

                Spacer()
                DatePicker(
                    "Select Time",
                    selection: $sleepTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()

                Text("What time do you wake up?")
                    .font(.headline)
                    .foregroundColor(.gray.opacity(0.8))

                Spacer()
                DatePicker(
                    "Select Time",
                    selection: $wakeTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()

                Spacer()
                Text("Different people sleep at different hours.")
                    .font(.footnote)

                    .foregroundColor(.gray.opacity(0.8))

                NavigationLink {
                    MealTimeView(hasSeenOnboarding: $hasSeenOnboarding)
                } label: {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .padding()
            .navigationTitle("Sleep Time")
        }
    }
}

struct MealTime: Identifiable, Codable {
    let id: UUID
    var mealType: String
    var time: Date
    var duration: Int
    
    init(id: UUID = UUID(), mealType: String, time: Date, duration: Int) {
        self.id = id
        self.mealType = mealType
        self.time = time
        self.duration = duration   
    }
}


struct MealTimeView: View {
    @State private var mealTimes: [MealTime] = []
    @State private var showingAddMeal = false
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
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
            NavigationStack {
                VStack(spacing: 20) {
                    Text("When do you have your meals?")
                        .font(.headline)

                        .foregroundColor(.gray.opacity(0.8))

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(mealTimes) { meal in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(meal.mealType)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    HStack {
                                        Label("\(meal.duration) min", systemImage: "timer")
                                        Label(meal.time.formatted(date: .omitted, time: .shortened),
                                              systemImage: "clock")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05),
                                        radius: 6,
                                        x: 0,
                                        y: 4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        Button {
                            showingAddMeal = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        Spacer()
                        NavigationLink {
                           ActivitiesView(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .navigationTitle("Meals")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingAddMeal) {
                    AddMealTimeView { newMeal in
                        mealTimes.append(newMeal)
                    }
                }
            }
        }
    }
}

struct ActivitiesView: View {
    @State private var activities: [Activity] = []
    @State private var showingAddActivity = false
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Do you have any recurring activities?")
                        .font(.headline)

                        .foregroundColor(.gray.opacity(0.5))

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(activities) { activity in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(activity.name)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    HStack {
                                        Label(activity.day, systemImage: "calendar")
                                        Label(activity.regularity, systemImage: "repeat")
                                        Label(activity.timeFormatted, systemImage: "clock")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        Button {
                            showingAddActivity = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        Spacer()
                        NavigationLink {
                            RestDaysView(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Activites")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddActivity) {
                AddActivitiesView(activities: $activities)
            }
        }
    }
}

struct Activity: Identifiable {
    let id = UUID()
    var name: String
    var day: String
    var regularity: String
    var time: Date
    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

struct RestActivity: Identifiable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
}

struct RestDaysView: View {
    
    @State private var restActivities: [RestActivity] = []
    @State private var showingAddSheet = false
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            NavigationStack {
                VStack(spacing: 20) {
                    Text("When do you rest?")
                        .font(.headline)

                        .foregroundColor(.gray.opacity(0.5))

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(restActivities) { activity in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(activity.name)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    HStack {
                                        Label(
                                            activity.startDate.formatted(date: .abbreviated, time: .omitted),
                                            systemImage: "sunrise"
                                        )
                                        Label(
                                            activity.endDate.formatted(date: .abbreviated, time: .omitted),
                                            systemImage: "sunset"
                                        )
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    Spacer()
                    HStack(spacing: 20) {
                        Button {
                            showingAddSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                        Spacer()
                        Button {
                            hasSeenOnboarding = true
                        } label: {
                            Text("Get started!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .navigationTitle("Rest Days")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingAddSheet) {
                    AddRestActivityView(restActivities: $restActivities)
                }
            }
        }
    }
}

struct AddMealTimeView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMeal = "Breakfast"
    @State private var mealTime = Date()
    @State private var durationHours: Int = 0
    @State private var durationMinutes: Int = 15
    
    let mealOptions = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var onSave: (MealTime) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("MEAL TYPE")) {
                    Picker("Select Meal", selection: $selectedMeal) {
                        ForEach(mealOptions, id: \.self) { meal in
                            Text(meal)
                        }
                    }
                }
                
                Section(header: Text("TIME")) {
                    DatePicker("Meal Time", selection: $mealTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("DURATION")) {
                    HStack {
                    Picker("Hours", selection: $durationHours) {
                        ForEach(0..<24) { hour in
                            Text("\(hour) h")
                        }
                    }
                    .pickerStyle( .wheel)
                    .frame(maxWidth: .infinity)
                    
                    Picker("Minutes", selection: $durationMinutes) {
                        ForEach(0..<60) { min in
                            Text("\(min) m")
                        }
                    }
                    .pickerStyle( .wheel)
                }
                }
                
                Section {
                    Button("Save") {
                        let totalMinutes = durationHours * 60 + durationMinutes
                        
                        onSave(
                            MealTime(mealType: selectedMeal,
                                     time: mealTime,
                                     duration: totalMinutes)
                        )
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Meal Time")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
        }
    }
}

struct AddActivitiesView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activities: [Activity]
    
    @State private var name: String = ""
    @State private var day: String = "Monday"
    @State private var regularity: String = "Weekly"
    @State private var time: Date = Date()
    @State private var duration: Int = 15
    
    
    let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let regularOptions = ["Daily","Weekly","Monthly"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                   
                    Text("Activity Name").font(.headline)
                    TextField("e.g. Gym", text: $name)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    
                    Text("Day").font(.headline)
                    Picker("Day", selection: $day) {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Text("Regularity").font(.headline)
                    Picker("Regularity", selection: $regularity) {
                        ForEach(regularOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Text("Time").font(.headline)
                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    Section(header: Text("Duration (min)")) {
                        Stepper("\(duration) min", value: $duration, in: 5...120, step: 5)
                    }
                    
                    Button {
                        let newActivity = Activity(name: name, day: day, regularity: regularity, time: time)
                        activities.append(newActivity)
                        dismiss()
                    }label:{
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct RestActivityy: Identifiable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
}

struct AddRestActivityView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var restActivities: [RestActivity]
    
    @State private var name: String = ""
   
    @State private var startDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var endDate: Date = Calendar.current.startOfDay(for: Date())
    
   
    private var isFormComplete: Bool {
        
        !name.isEmpty && startDate <= endDate
    }
    
    var body: some View {
        NavigationStack {
           
            Form {
              
                Section(header: Text("Activity name")) {
                    TextField("e.g., Vacation, Staycation, Sick Leave", text: $name)
                }
                
                Section(header: Text("REST PERIOD")) {
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
               
                Section {
                    Button("Save") {
                        let newActivity = RestActivity(name: name, startDate: startDate, endDate: endDate)
                        restActivities.append(newActivity)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isFormComplete)
                }
            }
            .navigationTitle("Add Rest Day")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

    
    struct OnboardingView_Previews: PreviewProvider {
        static var previews: some View {
            OnboardingView(hasSeenOnboarding: .constant(false))
        }
    }


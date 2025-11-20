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

struct ChronotypeView: View {
    @AppStorage("selectedChronotype") private var selectedChronotype: String?
    @Binding var hasSeenOnboarding: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // MAIN CONTENT
            VStack(spacing: 30) {
                Text("What is your chronotype?")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                    .foregroundColor(.black.opacity(0.5))

                // EARLY BIRD
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

                // NIGHT OWL
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
            }
            .padding(.bottom, 80) // Prevent overlap with button

            // BOTTOM-RIGHT BUTTON (Overlay)
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
            .padding(.trailing, 20)
            .padding(.bottom, 20)

        }
        .navigationTitle("Chronotype")
    }
}


struct NapTimeView: View {
   
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

    @EnvironmentObject var mealStore: MealTimeStore
    @Binding var hasSeenOnboarding: Bool

    @State private var showingAddMeal = false
    @State private var editingMeal: MealTime? = nil   // EDIT MODE

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

                            ForEach(mealStore.meals) { meal in

                                // TAPPABLE — OPEN EDIT MODE
                                Button {
                                    editingMeal = meal
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(meal.mealType)
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        HStack {
                                            Label("\(meal.duration) min", systemImage: "timer")
                                            Label(
                                                meal.time.formatted(date: .omitted, time: .shortened),
                                                systemImage: "clock"
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
                        .padding(.leading, 25)
                        .padding(.bottom, 25)

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
                // ADD MODE
                .sheet(isPresented: $showingAddMeal) {
                    AddMealTimeView(meal: nil) { newMeal in
                        mealStore.meals.append(newMeal)
                    }
                }
                // EDIT MODE
                .sheet(item: $editingMeal) { meal in
                    AddMealTimeView(meal: meal) { updated in
                        if let i = mealStore.meals.firstIndex(where: { $0.id == updated.id }) {
                            mealStore.meals[i] = updated
                        }
                    }
                }
            }
        }
    }
}


import SwiftUI

struct ActivitiesView: View {
    @EnvironmentObject var activityStore: ActivityStore
    @Binding var hasSeenOnboarding: Bool

    @State private var showingAdd = false
    @State private var editingActivity: Activity? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.2),
                    Color.blue.opacity(0.6)
                ],
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

                            ForEach(activityStore.activities) { activity in
                                Button {
                                    editingActivity = activity
                                } label: {
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
                                    .shadow(color: .black.opacity(0.05),
                                            radius: 6, x: 0, y: 4)
                                }
                            }

                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    Spacer()

                    HStack {
                        // Floating + Button
                        Button {
                            showingAdd = true
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
                .navigationTitle("Activities")
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddActivitiesView(activity: nil) { new in
                activityStore.activities.append(new)
            }
        }
        .sheet(item: $editingActivity) { activity in
            AddActivitiesView(activity: activity) { updated in
                if let i = activityStore.activities.firstIndex(where: { $0.id == updated.id }) {
                    activityStore.activities[i] = updated
                }
            }
        }
    }
}

struct Activity: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var day: String
    var regularity: String
    var time: Date

    var timeFormatted: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }

    init(id: UUID = UUID(), name: String, day: String, regularity: String, time: Date) {
        self.id = id
        self.name = name
        self.day = day
        self.regularity = regularity
        self.time = time
    }
}



struct RestActivity: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var startDate: Date
    var endDate: Date

    init(id: UUID = UUID(), name: String, startDate: Date, endDate: Date) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }
}


struct RestDaysView: View {

    @EnvironmentObject var restStore: RestActivityStore
    @Binding var hasSeenOnboarding: Bool

    @State private var showingAddSheet = false
    @State private var editingActivity: RestActivity? = nil   // EDIT MODE

    var body: some View {
        NavigationStack {
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

                VStack(spacing: 20) {

                    Text("When do you rest?")
                        .font(.headline)
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.top)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {

                            ForEach(restStore.activities) { activity in

                                Button {
                                    editingActivity = activity
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(activity.name)
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        HStack {
                                            Label(activity.startDate.formatted(date: .abbreviated, time: .omitted),
                                                  systemImage: "sunrise")
                                            Label(activity.endDate.formatted(date: .abbreviated, time: .omitted),
                                                  systemImage: "sunset")
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

                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    Spacer(minLength: 40)
                }

                // ADD BUTTON
                VStack {
                    Spacer()
                    HStack {
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
                        .padding(.leading, 25)
                        .padding(.bottom, 25)
                        Spacer()
                    }
                }

                // NEXT BUTTON
                VStack {
                    Spacer()
                    HStack {
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
                        .padding(.trailing, 25)
                        .padding(.bottom, 25)
                    }
                }
            }
            .navigationTitle("Rest Days")
            // ADD MODE
            .sheet(isPresented: $showingAddSheet) {
                AddRestActivityView(activity: nil) { newActivity in
                    restStore.activities.append(newActivity)
                }
            }
            // EDIT MODE
            .sheet(item: $editingActivity) { activity in
                AddRestActivityView(activity: activity) { updated in
                    if let i = restStore.activities.firstIndex(where: { $0.id == updated.id }) {
                        restStore.activities[i] = updated
                    }
                }
            }
        }
    }
}

struct AddMealTimeView: View {
    @Environment(\.dismiss) private var dismiss

    var meal: MealTime? = nil          // nil = add mode

    @State private var mealType: String = ""
    @State private var time: Date = Date()
    
    // Wheel picker values
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 30   // default
    
    // Convert hours + minutes into total minutes for saving
    private func totalDuration() -> Int {
        (selectedHours * 60) + selectedMinutes
    }

    // Extract hours + minutes when editing
    private func setInitialSelections() {
        guard let meal = meal else { return }
        selectedHours = meal.duration / 60
        selectedMinutes = meal.duration % 60
        mealType = meal.mealType
        time = meal.time
    }

    // Dummy max values so wheel works
    private let maxHours = 5
    private let maxMinutes = 59

    var onSave: (MealTime) -> Void

    var body: some View {
        NavigationStack {
            Form {
                
                TextField("Meal Type", text: $mealType)

                DatePicker("Time",
                           selection: $time,
                           displayedComponents: .hourAndMinute)

                // ********** YOUR CUSTOM WHEEL DURATION PICKER **********
                VStack(alignment: .leading) {
                    Text("Duration")
                        .font(.headline)

                    HStack {
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(0...maxHours, id: \.self) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)

                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0...maxMinutes, id: \.self) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                    .frame(height: 120)   // wheel height
                    .background(Color.white)
                    .cornerRadius(12)
                }
                // *******************************************************
            }
            .navigationTitle(meal == nil ? "Add Meal" : "Edit Meal")
            .onAppear(perform: setInitialSelections)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updatedMeal = MealTime(
                            id: meal?.id ?? UUID(),
                            mealType: mealType,
                            time: time,
                            duration: totalDuration()
                        )
                        onSave(updatedMeal)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}


import SwiftUI

struct AddActivitiesView: View {
    @Environment(\.dismiss) var dismiss

    var activity: Activity? = nil
    var onSave: (Activity) -> Void

    @State private var name: String = ""
    @State private var day: String = "Monday"
    @State private var regularity: String = "Weekly"
    @State private var time: Date = Date()

    let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let regularOptions = ["Daily","Weekly","Monthly"]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Activity Name")) {
                    TextField("e.g. Gym", text: $name)
                }

                Section(header: Text("Day")) {
                    Picker("Day", selection: $day) {
                        ForEach(days, id: \.self) { Text($0) }
                    }
                }

                Section(header: Text("Regularity")) {
                    Picker("Regularity", selection: $regularity) {
                        ForEach(regularOptions, id: \.self) { Text($0) }
                    }
                }

                Section(header: Text("Time")) {
                    DatePicker("",
                               selection: $time,
                               displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
            .navigationTitle(activity == nil ? "Add Activity" : "Edit Activity")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = Activity(
                            id: activity?.id ?? UUID(),
                            name: name,
                            day: day,
                            regularity: regularity,
                            time: time
                        )
                        onSave(updated)
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let a = activity {
                    name = a.name
                    day = a.day
                    regularity = a.regularity
                    time = a.time
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
    @Environment(\.dismiss) private var dismiss

    var activity: RestActivity? = nil   // nil = add mode
    var onSave: (RestActivity) -> Void

    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    var body: some View {
        NavigationStack {
            Form {
                TextField("E.g.Vacation, Sick, Public Holiday", text: $name)

                DatePicker("Start Date",
                           selection: $startDate,
                           displayedComponents: .date)

                DatePicker("End Date",
                           selection: $endDate,
                           displayedComponents: .date)
            }
            .navigationTitle(activity == nil ? "Add Rest Day" : "Edit Rest Day")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updated = RestActivity(
                            id: activity?.id ?? UUID(),
                            name: name,
                            startDate: startDate,
                            endDate: endDate
                        )
                        onSave(updated)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                if let a = activity {
                    name = a.name
                    startDate = a.startDate
                    endDate = a.endDate
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

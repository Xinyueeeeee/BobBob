
import SwiftUI

struct OnboardingView: View {
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
       @Environment(\.dismiss) var dismiss
       @State var isPressed: Bool = false
    var body: some View {
        NavigationStack {
            IntroductionCarouselView()
        }
    }
}
struct IntroductionCarouselView: View {
    @State private var index = 0
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [
                    Color(red: 10/255, green: 25/255, blue: 47/255),   // deep navy
                    Color(red: 25/255, green: 60/255, blue: 120/255)   // soft blue
                ],
                startPoint: .top,
                endPoint: .bottom
            )

                .ignoresSafeArea()

            TabView(selection: $index) {
                IntroductionScreenView1()
                    .tag(0)
                
                IntroductionScreenView2()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
}
struct IntroductionScreenView1: View {
    var body: some View {
        ZStack{
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
                NavigationLink{
                    HabitualStyleView()
                }label: {
                    Text("Let's get started!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 180/255, green: 220/255, blue: 255/255))
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                        .foregroundColor(Color(red: 45/255, green: 90/255, blue: 150/255))
                }
                
                .padding(.horizontal)
                .padding(.bottom,80)
            }
            .padding()
        }
    }
struct HabitualStyleView: View {
    @State private var selectedStyle: String? = nil
    
    var body: some View {
        ZStack{
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
                    .foregroundColor(.black).opacity(0.5)
                
                Button {
                    selectedStyle = "Hopper"
                }label: {
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
                
                
                
                Button{
                    selectedStyle = "Hyperfocus"
                }label:{
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
                    .foregroundColor(.gray.opacity(8.0))
                
                
                NavigationLink{
                    ChronotypeView()
                }label: {
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

    
    var body: some View {
        ZStack{
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
                    .foregroundColor(.black).opacity(0.5)
                Button{
                    selectedChronotype = "Early Bird"
                }label:{
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Early Bird")
                            .font(.headline)
                            .foregroundColor(selectedChronotype == "Early Bird" ? .white : .black)
                        
                        Text("You prefer starting your day earlier and feel most productive in the morning.")
                            .font(.subheadline)
                            .foregroundColor(selectedChronotype == "Early Bird" ? .white.opacity(0.9) : .black.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedChronotype == "Early Bird" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)
                
                Button {
                    selectedChronotype = "Night Owl"
                }label:{
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Night Owl")
                            .font(.headline)
                            .foregroundColor(selectedChronotype == "Night Owl" ? .white : .black)
                        
                        Text("You focus better later in the day and prefer working at night.")
                            .font(.subheadline)
                            .foregroundColor(selectedChronotype == "Night Owl" ? .white.opacity(0.9) : .black.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedChronotype == "Night Owl" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)
                
                Spacer()
                Spacer()
                
                Text("Different people prefer working at different time periods.")
                    .font(.footnote)
                    .foregroundColor(.black.opacity(0.5))
                
                NavigationLink{
                    NapTimeView()
                }label:{
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .navigationTitle("Chronotype")
            
        }
    }
}

    


struct NapTimeView: View {
            @AppStorage("sleepTime") private var sleepTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        @AppStorage("wakeTime") private var wakeTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!

    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                Text("What time do you go to sleep?")
                    .font(.headline)
                    .foregroundColor(.black).opacity(0.5)
                
                Spacer()
                
                DatePicker(
                    "Select Time",
                    selection: $sleepTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                
                Text("What time do you wake up?")
                    .font(.headline)
                    .foregroundColor(.black).opacity(0.5)
                
                Spacer()
                
                DatePicker(
                    "Select Time",
                    selection: $wakeTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                
                Spacer()
                
                Text("Different people sleep at different hours.")
                    .font(.footnote)
                    .foregroundColor(.black).opacity(0.5)
                
                NavigationLink {
                    MealTimeView()
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


struct MealTime: Identifiable {
    let id = UUID()
    var mealType: String
    var time: Date
    var duration: Int
}

struct MealTimeView: View {
    @State private var mealTimes: [MealTime] = []
    @State private var showingAddMeal = false
    
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
                        .foregroundColor(.black)
                        .opacity(0.5)
                    
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
                            ActivitiesView()
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
                        .foregroundColor(.black).opacity(0.5)
                    
                    
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
                        
                        NavigationLink{ RestDaysView()
                        }label: {
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
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false

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
                        .foregroundColor(.black).opacity(0.5)
                    
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
                            isWelcomeScreenOver = true
                        } label: {
                            Text("Get Started!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .navigationTitle("Rest Days")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddRestActivityView(restActivities: $restActivities)
        }
    }
}


#Preview {
    OnboardingView()
}

//
//  Onboarding.swift
//  BobBob
//
//  Created by Hanyi on 14/11/25.
//

import SwiftUI

struct OnboardingView: View {
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
                NavigationLink(destination: HabitualStyleView()) {
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
                    .foregroundColor(.gray)
                
                Button(action: {
                    selectedStyle = "Hopper"
                }) {
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
                
                
                
                Button(action: {
                    selectedStyle = "Hyperfocus"
                }) {
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
                    .foregroundColor(.black.opacity(0.5))
                
                
                NavigationLink(destination: ChronotypeView()) {
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
    @State private var selectedChronotype: String? = nil
    
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
                    .foregroundColor(.gray)
                Button(action: {
                    selectedChronotype = "Early Bird"
                }) {
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
                
                Button(action: {
                    selectedChronotype = "Night Owl"
                }) {
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
                
                NavigationLink(destination: NapTimeView()) {
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
    @State private var sleepTime = Date()
    
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
                .foregroundColor(.gray)
            
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
                .foregroundColor(.gray)
            
            Spacer()
            
            DatePicker(
                "Select Time",
                selection: $sleepTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            Spacer()
            
            NavigationLink(destination: MealTimeView()) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                .cornerRadius(10)            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .padding()
        .navigationTitle("Sleep Time")
    }
    }
}
struct MealTimeView: View {
    @State private var selectedMeal: String? = nil
    @State private var breakfastTime = Date()
    @State private var lunchTime = Date()
    @State private var dinnerTime = Date()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
        VStack(spacing: 20) {
            Text("When do you have your meals?")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
            
            mealButton(title: "Breakfast", isSelected: selectedMeal == "Breakfast", time: $breakfastTime)
            mealButton(title: "Lunch", isSelected: selectedMeal == "Lunch", time: $lunchTime)
            mealButton(title: "Dinner", isSelected: selectedMeal == "Dinner", time: $dinnerTime)
            
            Spacer()
            
            NavigationLink(destination: ActivitiesView()) {
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
        .navigationTitle("Meal Times")
    }
}
    @ViewBuilder
    private func mealButton(title: String, isSelected: Bool, time: Binding<Date>) -> some View {
        VStack(spacing: 5) {
            Button(action: {
                withAnimation {
                    selectedMeal = (selectedMeal == title) ? nil : title
                }
            }) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSelected ? Color.blue : Color.white)
                    .foregroundColor(isSelected ? .white : .black)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
            }
            
            if isSelected {
                VStack(spacing: 10) {
                    DatePicker(
                        "Select Time",
                        selection: time,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    
                    Button(action: {
                        print("\(title) saved: \(time.wrappedValue)")
                        selectedMeal = nil
                    }) {
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
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
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
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.2),
                    Color.blue.opacity(0.45)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Do you have any recurring activities?")
                    .font(.title3.bold())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                
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
                    
                    NavigationLink(destination: RestDaysView()) {
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
            .navigationTitle("")
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
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("When do you rest?")
                    .font(.headline)
                    .foregroundColor(.gray)
               
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(restActivities) { activity in
                            HStack {
                                Text(activity.name).frame(maxWidth: .infinity, alignment: .leading)
                                Text(activity.startDate, style: .date).frame(maxWidth: .infinity, alignment: .leading)
                                Text(activity.endDate, style: .date).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                    NavigationLink(destination: ContentView())
                    {
                        Text("Get started!")
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
            }
            .navigationTitle("Rest Days")
            .sheet(isPresented: $showingAddSheet) {
                AddRestActivityView(restActivities: $restActivities)
            }
        }
    }
}


#Preview {
    OnboardingView()
}

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
        TabView(selection: $index) {
            IntroductionScreenView1()
                .tag(0)

            IntroductionScreenView2()
                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}
struct IntroductionScreenView1: View {
    var body: some View {
        ZStack{
            VStack {
                Spacer()
                Text("Welcome")
                    .font(.largeTitle).bold()
                
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
                .font(.largeTitle).bold()
            
            Text("your working style")
                .padding(.bottom, 40)
                .foregroundColor(.gray)
            NavigationLink(destination: HabitualStyleView()) {
                Text("Let's get started!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 4)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
    struct HabitualStyleView: View {
        @State private var selectedStyle: String? = nil

        var body: some View {
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
                    .foregroundColor(.gray)

               
                NavigationLink(destination: ChronotypeView()) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)

            }
            .navigationTitle("Habitual Style")
        }
    }

struct ChronotypeView: View {
    @State private var selectedChronotype: String? = nil

    var body: some View {
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
            
            NavigationLink(destination: NapTimeView()) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .navigationTitle("Chronotype")
    }
}



struct NapTimeView: View {
    @State private var sleepTime = Date()
    
    var body: some View {
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
import SwiftUI

struct MealTimeView: View {
    @State private var selectedMeal: String? = nil
    @State private var breakfastTime = Date()
    @State private var lunchTime = Date()
    @State private var dinnerTime = Date()
    
    var body: some View {
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
        VStack(spacing: 10) {
            Text("Do you have any recurring activities?")
                .font(.headline)
                .foregroundColor(.gray)
            HStack {
                Text("Activity Name").bold().frame(maxWidth: .infinity, alignment: .leading)
                Text("Day").bold().frame(maxWidth: .infinity, alignment: .leading)
                Text("Regularity").bold().frame(maxWidth: .infinity, alignment: .leading)
                Text("Time").bold().frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(activities) { activity in
                        HStack {
                            Text(activity.name).frame(maxWidth: .infinity, alignment: .leading)
                            Text(activity.day).frame(maxWidth: .infinity, alignment: .leading)
                            Text(activity.regularity).frame(maxWidth: .infinity, alignment: .leading)
                            Text(activity.time, style: .time).frame(maxWidth: .infinity, alignment: .leading)
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
                    showingAddActivity = true
                }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(10)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding()
        }
        .navigationTitle("Activities")
        .sheet(isPresented: $showingAddActivity) {
            AddActivitiesView(activities: $activities)
        }
    }
}
struct Activity: Identifiable {
    let id = UUID()
    var name: String
    var day: String
    var regularity: String
    var time: Date
}

struct RestDaysView: View {
    var body: some View {
        VStack {
            Text("Rest Days")
                .font(.headline)

            Spacer()

            Button("Get started!") {
                print("Done")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Rest Days")
    }
}

#Preview {
    OnboardingView()
}

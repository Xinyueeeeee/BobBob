//
//  Onboarding.swift
//  BobBob
//
//  Created by Hanyi on 14/11/25.
//

import SwiftUI



struct OnboardingView: View {
    
    var body: some View {
        ZStack{
            
            TabView{
                IntroductionScreenView(title: "WELCOME", description: "A task organiser that adapts to the way you acually work", imageName: "", isStartingPage: false)
                
                IntroductionScreenView(title: "", description: "Find your working style", imageName: "", isStartingPage: true)
                
                HabitualStyleView()
                
                ChronotypeView()
                
                NapTimeView()
                
                MealTimeView()
                
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
           
        }
    }
}
struct IntroductionScreenView : View {
    let title : String
    let description : String
    let imageName : String
    let isStartingPage: Bool
  
    @State private var isSheetPresented = false
    
    var body : some View {
        VStack {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
        Text(description)
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        
            if isStartingPage {
                Button {
                } label: {
                    Text("NEXT")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(color:Color.black.opacity(0.3),radius: 5, x:0,y:3)
                }
            }
        }
    }
}

struct HabitualStyleView : View {
    var body: some View {
        VStack{
            Text("What is your habitual style?")
                .font( .title)
            Button{
            } label: {
                Text("Hopper")
                    .font(.title3)
                Text("Someone who concentrates on a task for short bursts of time")
                
            }
            Button{
            } label: {
                Text("Hyperfocus")
                    .font(.title3)
                Text("Someone who concentrates on a task for a long period of time")
            }
        }
    }
}

struct ChronotypeView : View {
    var body: some View {
        VStack{
            Text("What is your working preference?")
            Button{
            } label: {
                Text("Early Bird")
            }
            Button{
            }label:{
                Text("Night Owl")
            }
        }
    }
}

struct NapTimeView: View {
    @State private var selectedTime = Calendar.current.date(
        bySettingHour: 8,
        minute: 0,
        second: 0,
        of: Date()
    )!

    var body: some View {
        VStack{
            Text("What time do you sleep?")
            DatePicker(
                "Select Time",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
        }
    }
}

import SwiftUI

struct MealTimeView: View {
    @State private var selectedMeal: MealType? = nil
    @State private var breakfastTime = Date()
    @State private var lunchTime = Date()
    @State private var dinnerTime = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("When do you have your meals?")
                .font(.title3)
                .bold()
            
            mealButton(title: "Breakfast", meal: .breakfast)
            if selectedMeal == .breakfast {
                DatePicker("",
                           selection: $breakfastTime,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            }
            
            mealButton(title: "Lunch", meal: .lunch)
            if selectedMeal == .lunch {
                DatePicker("",
                           selection: $lunchTime,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            }
            
            mealButton(title: "Dinner", meal: .dinner)
            if selectedMeal == .dinner {
                DatePicker("",
                           selection: $dinnerTime,
                           displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
            }
            
            Spacer()
        }
        .padding()
    }
    
   
    @ViewBuilder
    func mealButton(title: String, meal: MealType) -> some View {
        Button {
            withAnimation {
                selectedMeal = (selectedMeal == meal) ? nil : meal
            }
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedMeal == meal ? Color.blue : Color.white)
                .foregroundColor(selectedMeal == meal ? .white : .black)
                .cornerRadius(12)
                .shadow(radius: 2)
        }
    }
}

enum MealType {
    case breakfast, lunch, dinner
}


#Preview {
    OnboardingView()
}

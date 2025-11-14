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

#Preview {
    OnboardingView()
}

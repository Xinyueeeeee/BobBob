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
        VStack {
            Spacer()
            Text("Welcome")
                .font(.largeTitle).bold()

            Text("to a task organiser that adapts to the way you actually work")
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .padding()
        .background(Color(.systemBlue).opacity(0.2))
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

            NavigationLink(destination: HabitualStyleView()) {
                Text("Let's get started!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .background(Color(.systemBlue).opacity(0.2))
    }
}
struct HabitualStyleView: View {
    var body: some View {
        VStack {
            Text("What is your habitual style?")
                .font(.headline)

            Spacer()

            NavigationLink("Next", destination: ChronotypeView())
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Habitual Style")
    }
}
struct ChronotypeView: View {
    var body: some View {
        VStack {
            Text("What is your chronotype?")
                .font(.headline)

            Spacer()

            NavigationLink("Next", destination: NapTimeView())
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Chronotype")
    }
}
struct NapTimeView: View {
    var body: some View {
        VStack {
            Text("What time do you go to sleep?")
                .font(.headline)

            Spacer()

            NavigationLink("Next", destination: MealTimeView())
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Sleep Time")
    }
}
struct MealTimeView: View {
    var body: some View {
        VStack {
            Text("When do you have your meals?")
                .font(.headline)

            Spacer()

            NavigationLink("Next", destination: ActivitiesView())
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Meal Times")
    }
}
struct ActivitiesView: View {
    var body: some View {
        VStack {
            Text("Other scheduled activities")
                .font(.headline)

            Spacer()

            NavigationLink("Next", destination: RestDaysView())
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .navigationTitle("Activities")
    }
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

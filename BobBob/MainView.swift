//
//  MainView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//
import SwiftUI

struct MainView: View {
    @Binding var hasSeenOnboarding: Bool
    @State var checkWelcomeScreen: Bool = false
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                ContentView(hasSeenOnboarding: $hasSeenOnboarding)
            } else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
            }
        }
        
    }
}

#Preview {
    MainView(hasSeenOnboarding: .constant(false))
}

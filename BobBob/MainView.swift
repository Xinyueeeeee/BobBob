//
//  MainView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//
import SwiftUI

struct MainView: View {
    
    @AppStorage("isWelcomeScreenOver") var isWelcomeScreenOver = false
    @State var checkWelcomeScreen: Bool = false
    
    var body: some View {
        VStack {
            if checkWelcomeScreen {
                ContentView()
            } else {
                OnboardingView()
            }
        }
        
    }
}

#Preview {
    MainView()
}

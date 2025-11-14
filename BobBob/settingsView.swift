//
//  settingsView.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//


import SwiftUI

struct settingsView: View {
    
    var body: some View {
        
        ZStack {
            NavigationStack{
                VStack{
                    Form {
                        Section(header: Text("general")) {
                            Text("notifications")
                        }.listRowBackground(Color.white)

                        Section(header: Text("integrations")) {
                            Text("apple calender")
                        }.listRowBackground(Color.white)
                        
                        Section(header: Text("personal information")) {
                            Text("habitual styles")
                            Text("chronotype")
                            Text("meal timings")
                            Text("other activities")
                        }.listRowBackground(Color.white)
                    }
                }.navigationTitle("Settings")
            }
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}
#Preview {
    settingsView()
}

//
//  settingsView.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//


import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
            NavigationStack{
                VStack{
                    Form {
                        Section(header: Text("General")) {
                            NavigationLink{
                                NotifsView()
                            }label:{
                                Text("Notifications")
                            }
                        }
                        
                        Section(header: Text("Integrations")) {
                            NavigationLink{
                                NotifsView()
                            }label:{
                                Text("Apple Calendar")
                            }
                        }
                        
                        Section(header: Text("Personal Information")) {
                            NavigationLink{
                                HabitualStyleView2()
                            }label: {
                                Text("Habitual Style")
                            }
                            NavigationLink{
                                ChronotypeView2()
                            }label:{
                                Text("Chronotype")
                            }
                            NavigationLink{
                                MealTimeView2()
                            }label:{
                                Text("Meal Time")
                            }
                            NavigationLink{
                                NapTimeView2()
                            }label:{
                                Text("Sleep Schedule")
                            }
                            NavigationLink{
                                ActivitiesView2()
                            }label:{
                                Text("Activitiy")
                            }
                            NavigationLink{
                                RestDaysView2()
                            }label: {
                                Text("Rest Day")
                            }
                        }
                    }
                }.navigationTitle("Settings")
            }
            
        }
    }

#Preview {
    SettingsView()
}


struct NotifsView: View {
    @AppStorage("startOfTasks") private var startOfTasks: Bool = false
    @AppStorage("endOfTasks") private var endOfTasks: Bool = false
    @AppStorage("fiveMinBefTask") private var fiveMinBefTask: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $startOfTasks) {
                    Text("At the start of the task")
                }
                Toggle(isOn: $endOfTasks) {
                    Text("At the end of the tasks")
                }
                Toggle(isOn: $fiveMinBefTask) {
                    Text("5 minutes before task")
                }
            }
            .navigationTitle("Notifications")
        }
    }
}


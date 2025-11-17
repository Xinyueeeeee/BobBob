//
//  settingsView.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//


import SwiftUI

struct settingsView: View {
    
    var body: some View {
        
            NavigationStack{
                VStack{
                    Form {
                        Section(header: Text("general")) {
                            NavigationLink{
                                notifsView()
                            }label:{
                                Text("notifications")
                            }
                        }
                        
                        Section(header: Text("integrations")) {
                            NavigationLink{
                                notifsView()
                            }label:{
                                Text("apple calendar")
                            }
                        }
                        
                        Section(header: Text("personal information")) {
                            NavigationLink{
                                HabitualStyleView2()
                            }label: {
                                Text("habitual styles")
                            }
                            NavigationLink{
                                ChronotypeView2()
                            }label:{
                                Text("chronotype")
                            }
                            NavigationLink{
                                MealTimeView2()
                            }label:{
                                Text("meal timings")
                            }
                            NavigationLink{
                                NapTimeView2()
                            }label:{
                                Text("sleep schedule")
                            }
                            NavigationLink{
                                ActivitiesView2()
                            }label:{
                                Text("other activities")
                            }
                            NavigationLink{
                                RestDaysView2()
                            }label: {
                                Text("rest days")
                            }
                        }
                    }
                }.navigationTitle("Settings")
            }
            
        }
    }

#Preview {
    settingsView()
}


struct notifsView: View {
    @State private var startOfTasks: Bool = false
    @State private var endOfTasks: Bool = false
    @State private var fiveMinBefTask: Bool = false
    var body: some View {
        NavigationStack{
            VStack (alignment: .leading, spacing: 24){
                List{
                    Toggle(isOn: $startOfTasks) {
                        Text("at start of tasks")
                    }
                    Toggle(isOn: $endOfTasks) {
                        Text("at end of tasks")
                    }
                    Toggle(isOn: $fiveMinBefTask) {
                        Text("5 minutes before task")
                    }
                }
            }.navigationTitle(Text("Notifications"))
        }
    }
}

#Preview {
settingsView()
}


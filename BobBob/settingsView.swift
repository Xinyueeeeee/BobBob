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
                            NavigationLink(destination: notifsView()) {
                                Text("notifications")
                            }
                        }
                        
                        Section(header: Text("integrations")) {
                            NavigationLink(destination: notifsView()) {
                                Text("apple calendar")
                            }
                        }
                        
                        Section(header: Text("personal information")) {
                            NavigationLink(destination: HabitualStyleView2()) {
                                Text("habitual styles")
                            }
                            NavigationLink(destination: ChronotypeView()) {
                                Text("chronotype")
                            }
                            NavigationLink(destination: MealTimeView()) {
                                Text("meal timings")
                            }
                            NavigationLink(destination: ActivitiesView()) {
                                Text("other activities")
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


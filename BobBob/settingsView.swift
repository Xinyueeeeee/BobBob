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
                            NavigationLink(destination: HabitualStyleView()) {
                                Text("habitual styles")
                            }
                            NavigationLink(destination: ChronotypeView()) {
                                Text("chronotype")
                            }
                            NavigationLink(destination: notifsView()) {
                                Text("meal timings")
                            }
                            NavigationLink(destination: notifsView()) {
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
    
    var body: some View {
        VStack{
            Text("hi")
        }

    }
}

#Preview {
settingsView()
}


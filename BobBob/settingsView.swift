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
                        }

                        Section(header: Text("integrations")) {
                            Text("apple calender")
                        }
                        
                        Section(header: Text("personal information")) {
                            Text("habitual styles")
                            Text("chronotype")
                            Text("meal timings")
                            Text("other activities")
                        }
                    }
                }.navigationTitle("Settings")
            }
            
        }
    }
}
#Preview {
    settingsView()
}

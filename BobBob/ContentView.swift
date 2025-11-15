//
//  ContentView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView{
            Tab("calendar",systemImage: "calendar"){
                CalendarView()
            }
            Tab("tasks",systemImage: "list.bullet"){
                TasksView(totalSeconds: .constant(0))
            }
                    Tab("setttings",systemImage: "gearshape"){
                        settingsView()
            }
        }
    }
}


#Preview {
    ContentView()
}

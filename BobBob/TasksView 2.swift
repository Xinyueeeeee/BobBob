//
//  TasksView 2.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//


import SwiftUI

struct addTasksView: View {
    @State private var userName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .navigationTitle(Text("Add tasks"))
                
                ScrollView {
                VStack(alignment: .leading) {
                    
                        
                        Text("name")
                            .foregroundStyle(.black).opacity(0.5)
                        TextField("Enter your task name", text: $userName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        
                    }
                }
            }
        }
    }
}

#Preview {
    addTasksView()
}

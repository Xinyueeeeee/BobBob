//
//  TasksView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct TasksView: View {
    @State private var tasks: [Task] = []
    @State private var totalSeconds: Int = 0
    
    var body: some View {
        NavigationStack{
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ForEach(tasks) { task in
                        Text(task.name)
                            .font( .headline)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    Spacer()
                }.padding()
                
                NavigationLink(destination: addTasksView( totalSeconds: $totalSeconds, onSave: {task in tasks.append(task)})){
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                            .frame(width: 60, height: 60)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding()
                }.navigationTitle(Text("Tasks"))
            }
        }
    }

#Preview {
    TasksView()
}

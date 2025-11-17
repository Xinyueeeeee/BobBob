//
//  TasksView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct TasksView: View {
    @State private var tasks: [Task] = []
    
    // Only used when adding a task
    @State private var newTaskSeconds: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    
                    // List of tasks
                    ForEach($tasks) { $task in
                        NavigationLink {
                            addTasksView(
                                totalSeconds: $task.durationSeconds,   // <-- REAL BINDING
                                onSave: { updatedTask in
                                    task = updatedTask   // update this exact task
                                },
                                existingTask: task
                            )
                        } label: {
                            Text(task.name)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                // Add button
                NavigationLink(destination:
                                addTasksView(
                                    totalSeconds: $newTaskSeconds,   // NEW TASK state
                                    onSave: { task in
                                        tasks.append(task)
                                        newTaskSeconds = 0  // reset for next add
                                    },
                                    existingTask: nil
                                )
                ) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .frame(width: 60, height: 60)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()
                
            }
            .navigationTitle("Tasks")
        }
    }
}

#Preview {
    TasksView()
}

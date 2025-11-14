//
//  TasksView 2.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//

import SwiftUI

struct addTasksView: View {
    @State private var name: String = ""
    @State private var deadline: Date = Date()
    @State private var duration: String = ""
    @State private var prefersWorkingTime: Bool = false
    @State private var selectedDate: Date = Date()
    @State private var importance: Double = 0.5

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        Group {
                            Text("name")
                                .font(.headline)
                            TextField("", text: $name)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }

                        Group {
                            Text("deadline")
                                .font(.headline)
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }

                        Group {
                            Text("duration")
                                .font(.headline)
                            TextField("e.g. 2h30min", text: $duration)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }

                        Toggle(isOn: $prefersWorkingTime) {
                            Text("preferable working time")
                                .font(.headline)
                        }

                        if prefersWorkingTime {
                            VStack(alignment: .leading) {
                                DatePicker("Select time", selection: $selectedDate)
                                    .datePickerStyle(.graphical)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }

                        VStack(alignment: .leading) {
                            Text("importance")
                                .font(.headline)
                            Slider(value: $importance)
                            HStack {
                                Text("Most important")
                                Spacer()
                                Text("Least important")
                            }
                            .font(.caption)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Add tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        // save action
                    }
                }
            }
        }
    }
}

#Preview {
    addTasksView()
}

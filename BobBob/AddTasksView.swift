//
//  TasksView 2.swift
//  BobBob
//
//  Created by minyi on 14/11/25.
//

import SwiftUI

struct addTasksView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var deadline: Date = Date()
    
    @Binding var totalSeconds: Int
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    
    let maxHours = 23
    let maxMinutes = 59
    
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
                            TextField("e.g math project", text: $name)
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
                        
                        HStack {
                            Picker("Hours", selection: $selectedHours) {
                                ForEach(0...maxHours, id:\.self) { hour in
                                    Text("\(hour)h").tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            
                            Picker("Minutes", selection: $selectedMinutes) {
                                ForEach(0...maxMinutes, id:\.self) { minute in
                                    Text("\(minute)m").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                        .onChange(of: selectedHours) { updateTotalSeconds() }
                        .onChange(of: selectedMinutes) { updateTotalSeconds() }
                        .onAppear(perform: setInitialSelections)
                        
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
                        dismiss()
                    }
                }
            }
        }
    }
    private func setInitialSelections() {
        selectedHours = totalSeconds / 3600
        selectedMinutes = (totalSeconds % 3600) / 60
    }
    private func updateTotalSeconds() {
        totalSeconds = selectedHours * 3600 + selectedMinutes * 60
    }
}
#Preview {
    addTasksView(totalSeconds: .constant(0))
}

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
    var onSave: (Task) -> Void
    
    var existingTask: Task? = nil
    
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    
    let maxHours = 23
    let maxMinutes = 59
    
    @State private var prefersWorkingTime: Bool = false
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
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
                        
                        VStack(alignment: .leading) {
                            Text("duration")
                                .font(.headline)
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
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        
                        Toggle(isOn: $prefersWorkingTime) {
                            Text("preferable working time")
                                .font(.headline)
                        }
                        
                        if prefersWorkingTime {
                            workingTimeSection
                        }
                        
                        VStack(alignment: .leading) {
                            Text("importance")
                                .font(.headline)
                            Slider(value: $importance, in: 0...1, step: 0.5)
                            HStack {
                                Text("Most important")
                                Spacer()
                                Text("Least important")
                            }
                            .font(.caption)
                        }
                    }
                    .padding()
                    .onAppear {
                        if let task = existingTask {
                            name = task.name
                            deadline = task.deadline
                            totalSeconds = task.durationSeconds
                            importance = task.importance
                            if let s = task.startDate {startDate = s}
                            if let e = task.endDate {endDate = e}
                            prefersWorkingTime = task.startDate != nil || task.endDate != nil
                            
                            setInitialSelections()
                        }
                    }
                }
            }
            .navigationTitle("Add tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        let newTask = Task(name: name,
                                           deadline: deadline,
                                           durationSeconds: totalSeconds,
                                           importance: importance,
                                           startDate: prefersWorkingTime ? startDate : nil, endDate: prefersWorkingTime ? endDate : nil)
                        onSave(newTask)
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var workingTimeSection: some View {
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading) {
                Text("Start date")
                    .font(.subheadline)
                DatePicker(
                    "",
                    selection: $startDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
            }
            
            VStack(alignment: .leading) {
                Text("End date")
                    .font(.subheadline)
                DatePicker(
                    "",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .labelsHidden()
            }
            
            Text("\(formattedDateRange)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.top, 8)
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    private var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let s = formatter.string(from: startDate)
        let e = formatter.string(from: endDate)
        return "\(s) - \(e)"
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
    addTasksView(totalSeconds: .constant(0),
                 onSave: { _ in })
}

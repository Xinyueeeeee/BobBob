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
    
    @State private var importance: Double = 0.5
    private var canSave: Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard totalSeconds > 0 else { return false }
        return true
    }

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
                            Text("Name")
                                .font(.headline)
                            TextField("e.g Math Project", text: $name)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        Group {
                            Text("Deadline")
                                .font(.headline)
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        VStack(alignment: .leading) {
                            Text("Duration")
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
                        
                        VStack(alignment: .leading) {
                            Text("Importance")
                                .font(.headline)
                            Slider(value: $importance, in: 0...1, step: 0.5)
                            HStack {
                                Text("Least important")
                                Spacer()
                                Text("Most important")
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
                            
                            setInitialSelections()
                        }
                    }
                }
            }
            .navigationTitle(existingTask == nil ? "Add Task" : "Edit Task")

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        let newTask = Task(
                            name: name,
                            deadline: deadline,
                            durationSeconds: totalSeconds,
                            importance: importance,
                            startDate: nil,
                            endDate: nil
                        )
                        onSave(newTask)
                        dismiss()
                    }
                    .disabled(!canSave)
                    .opacity(canSave ? 1 : 0.4)
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
    addTasksView(totalSeconds: .constant(0),
                 onSave: { _ in })
}

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
    
    let maxHours = 24
    let maxMinutes = 59
    
    @State private var prefersTime: Bool = false
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    
    @State private var importance: Double = 0.5
    
    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        totalSeconds > 0
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                
                Section(header: Text("Name")) {
                    TextField("E.g. Science Project", text: $name)
                }
                
                Section(header: Text("Deadline")) {
                    DatePicker(
                        "Select Deadline",
                        selection: $deadline,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                Section(header: Text("Duration")) {
                    HStack {
                        Picker("Hours", selection: $selectedHours) {
                            ForEach(0...maxHours, id:\.self) { hour in
                                Text("\(hour)h").tag(hour)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                        
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0...maxMinutes, id:\.self) { minute in
                                Text("\(minute)m").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(maxWidth: .infinity)
                    }
                    .onChange(of: selectedHours) { updateTotalSeconds() }
                    .onChange(of: selectedMinutes) { updateTotalSeconds() }
                    .frame(height: 120)
                }
                
                Section(header: Text("Preferred Working Time")) {
                    Toggle("Enable", isOn: $prefersTime)
                    
                    if prefersTime {
                        // START TIME
                        DatePicker(
                            "Start",
                            selection: Binding(
                                get: { startDate ?? Date() },
                                set: {
                                    startDate = $0

                                    // Force endDate ≥ startDate
                                    if let end = endDate, end < $0 {
                                        endDate = $0
                                    }
                                }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )

                        // END TIME (cannot be earlier than start)
                        DatePicker(
                            "End",
                            selection: Binding(
                                get: { endDate ?? (startDate ?? Date()) },
                                set: { endDate = $0 }
                            ),
                            in: (startDate ?? Date())...,           // <-- prevents going earlier
                            displayedComponents: [.date, .hourAndMinute]
                        )

                    }
                }
                
                Section(header: Text("Importance")) {
                    VStack(alignment: .leading) {
                        Slider(value: $importance, in: 0...1, step: 0.5)
                        
                        HStack {
                            Text("Least important")
                            Spacer()
                            Text("Most important")
                        }
                        .font(.caption)
                    }
                }
            }
            
            .navigationTitle(existingTask == nil ? "New Task" : "Edit Task")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(true)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newTask = Task(
                            id: existingTask?.id ?? UUID(),
                            name: name,
                            deadline: deadline,
                            durationSeconds: totalSeconds,
                            importance: importance,
                            startDate: prefersTime ? startDate : nil,
                            endDate: prefersTime ? endDate : nil,
                            isCompleted: existingTask?.isCompleted ?? false
                        )
                        
                        onSave(newTask)
                        dismiss()
                    }
                    .disabled(!canSave)
                    .opacity(canSave ? 1 : 0.4)
                }
            }
        }
        .onAppear {
            if let task = existingTask {
                name = task.name
                deadline = task.deadline
                totalSeconds = task.durationSeconds
                importance = task.importance
                
                selectedHours = task.durationSeconds / 3600
                selectedMinutes = (task.durationSeconds % 3600) / 60
                
                prefersTime = task.startDate != nil
                startDate = task.startDate
                endDate = task.endDate
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
    
    private func updateTotalSeconds() {
        totalSeconds = selectedHours * 3600 + selectedMinutes * 60
    }
}

#Preview {
    addTasksView(
        totalSeconds: .constant(3600),
        onSave: { task in
            print("Saved task:", task)
        }
    )
}

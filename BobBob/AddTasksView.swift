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
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        totalSeconds > 0
    }

    var body: some View {

        NavigationStack {

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Group {
                        Text("Name")
                            .font(.headline)
                        TextField("E.g. Science Project", text: $name)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }

                    Group {
                        Text("Deadline")
                            .font(.headline)
                        DatePicker("", selection: $deadline, displayedComponents: [.date, .hourAndMinute])
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
                        .onChange(of: selectedHours) { _ in updateTotalSeconds() }
                        .onChange(of: selectedMinutes) { _ in updateTotalSeconds() }
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

                        selectedHours = task.durationSeconds / 3600
                        selectedMinutes = (task.durationSeconds % 3600) / 60
                    }
                }
            }

            .navigationTitle(existingTask == nil ? "Add Task" : "Edit Task")
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
                            startDate: existingTask?.startDate,
                            endDate: existingTask?.endDate,
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
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }

    private func updateTotalSeconds() {
        totalSeconds = selectedHours * 3600 + selectedMinutes * 60
    }
}

#Preview {
    addTasksView(totalSeconds: .constant(3600), onSave: { _ in })
}

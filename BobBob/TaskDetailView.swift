//
//  TaskDetailView.swift
//  BobBob
//
//  Created by Hanyi on 20/11/25.


import SwiftUI

struct TaskDetailView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskStore: TaskStore

    @State var item: Task
    @State private var showEdit = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // TITLE
                Text(item.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 10)

                // DEADLINE
                detailRow(
                    icon: "calendar",
                    title: "Deadline",
                    value: item.deadline.formatted(date: .abbreviated, time: .shortened)
                )

                // DURATION
                detailRow(
                    icon: "timer",
                    title: "Duration",
                    value: durationLabel(item.durationSeconds)
                )

                // PREFERRED TIME (optional)
                if let start = item.startDate, let end = item.endDate {
                    detailRow(
                        icon: "clock",
                        title: "Preferred Time",
                        value: "\(start.formatted(date: .abbreviated, time: .shortened)) → \(end.formatted(date: .abbreviated, time: .shortened))"
                    )
                }

                Spacer().frame(height: 40)

                // EDIT BUTTON
                Button(action: { showEdit = true }) {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit Task")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.9))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }

                // DELETE BUTTON
                Button(role: .destructive) {
                    deleteItem()
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Task")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.15))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEdit) {
            addTasksView(
                totalSeconds: Binding(
                    get: { item.durationSeconds },
                    set: { item.durationSeconds = $0 }
                ),
                onSave: { updated in
                    updateItem(updated)
                },
                existingTask: item
            )
        }
    }

    // MARK: - UPDATE TASK
    private func updateItem(_ updated: Task) {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == updated.id }) {
            taskStore.tasks[index] = updated
            item = updated
        }
    }

    // MARK: - DELETE TASK
    private func deleteItem() {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == item.id }) {
            taskStore.tasks.remove(at: index)
            dismiss()
        }
    }

    // MARK: - HELPER UI ROW
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
    }

    // MARK: - DURATION HELPER
    private func durationLabel(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h == 0 { return "\(m)m" }
        if m == 0 { return "\(h)h" }
        return "\(h)h \(m)m"
    }
}

struct TaskEditSheet: View {

    @Environment(\.dismiss) var dismiss

    @State var name: String
    @State var deadline: Date
    @State var durationSeconds: Int
    @State var startDate: Date?
    @State var endDate: Date?

    let task: Task
    var onSave: (Task) -> Void

    @State private var selectedHours = 0
    @State private var selectedMinutes = 0
    @State private var prefersTime = false

    init(task: Task, onSave: @escaping (Task) -> Void) {
        self.task = task
        self.onSave = onSave
        _name = State(initialValue: task.name)
        _deadline = State(initialValue: task.deadline)
        _durationSeconds = State(initialValue: task.durationSeconds)
        _startDate = State(initialValue: task.startDate)
        _endDate = State(initialValue: task.endDate)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Task Name") {
                    TextField("Name", text: $name)
                }

                Section("Deadline") {
                    DatePicker("Deadline", selection: $deadline)
                }

                Section("Duration") {
                    Picker("Hours", selection: $selectedHours) {
                        ForEach(0..<24) { Text("\($0)h") }
                    }

                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(0..<60) { Text("\($0)m") }
                    }
                }

                Toggle("Preferred Working Time", isOn: $prefersTime)

                if prefersTime {
                    DatePicker(
                        "Start Time",
                        selection: Binding(
                            get: { startDate ?? Date() },
                            set: { newValue in startDate = newValue }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )

                    DatePicker(
                        "End Time",
                        selection: Binding(
                            get: { endDate ?? Date() },
                            set: { newValue in endDate = newValue }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )

                }
            }
            .navigationTitle("Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let updatedTask = Task(
                            id: task.id,
                            name: name,
                            deadline: deadline,
                            durationSeconds: selectedHours * 3600 + selectedMinutes * 60,
                            importance: task.importance,
                            startDate: prefersTime ? startDate : nil,
                            endDate: prefersTime ? endDate : nil
                        )

                        onSave(updatedTask)
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedHours = durationSeconds / 3600
                selectedMinutes = (durationSeconds % 3600) / 60
                prefersTime = (startDate != nil)
            }
        }
    }
}


// MARK: - Helper Binding for optional Date
extension Binding where Value == Date? {
    init(_ source: Binding<Date?>, replacingNilWith defaultDate: Date) {
        self.init(
            get: { source.wrappedValue ?? defaultDate },
            set: { source.wrappedValue = $0 }
        )
    }
}


import SwiftUI
struct TaskDetailView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var scheduleVM: SchedulerViewModel

    @State var item: Task
    @State private var showEdit = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    Text(item.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.top, 10)

                    if let block = scheduleVM.allBlocks.first(where: { $0.task.id == item.id }),
                       block.isOverdue {
                        HStack(spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                            Text("This task was scheduled after its deadline")
                                .foregroundColor(.yellow)
                                .font(.headline)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.15))
                        .cornerRadius(12)
                    }

                    detailRow(
                        icon: "calendar",
                        title: "Deadline",
                        value: item.deadline.formatted(date: .abbreviated, time: .shortened)
                    )

                    detailRow(
                        icon: "timer",
                        title: "Duration",
                        value: durationLabel(item.durationSeconds)
                    )

                    if let start = item.startDate, let end = item.endDate {
                        detailRow(
                            icon: "clock",
                            title: "Preferred Time",
                            value: "\(start.formatted(date: .abbreviated, time: .shortened)) → \(end.formatted(date: .abbreviated, time: .shortened))"
                        )
                    }

                    Spacer().frame(height: 120)
                }
                .padding(.horizontal)
            }

            VStack(spacing: 12) {

                Button {
                    showEdit = true
                } label: {
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
            .padding(.horizontal)
            .padding(.bottom, 16)
            .background(Color(.systemGray6))
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEdit) {
            TaskEditSheet(task: item) { updated in
                updateItem(updated)
            }
        }
    }

    private func updateItem(_ updated: Task) {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == updated.id }) {
            taskStore.tasks[index] = updated
            item = updated
        }
    }

    private func deleteItem() {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == item.id }) {
            taskStore.tasks.remove(at: index)
            dismiss()
        }
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }

    private func durationLabel(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60

        switch (h, m) {
        case (0, _): return "\(m)m"
        case (_, 0): return "\(h)h"
        default: return "\(h)h \(m)m"
        }
    }
}

struct TaskEditSheet: View {

    @Environment(\.dismiss) var dismiss

    let task: Task
    var onSave: (Task) -> Void

    @State private var name: String
    @State private var deadline: Date
    @State private var durationSeconds: Int
    @State private var startDate: Date?
    @State private var endDate: Date?
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
        _prefersTime = State(initialValue: task.startDate != nil)
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
                        ForEach(0..<4) { Text("\($0)h") }
                    }

                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(0..<60) { Text("\($0)m") }
                    }
                }

                Toggle("Preferred Working Time", isOn: $prefersTime)

                if prefersTime {
                    DatePicker(
                        "Start",
                        selection: Binding(
                            get: { startDate ?? Date() },
                            set: { startDate = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )

                    DatePicker(
                        "End",
                        selection: Binding(
                            get: { endDate ?? Date() },
                            set: { endDate = $0 }
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
                        let updated = Task(
                            id: task.id,
                            name: name,
                            deadline: deadline,
                            durationSeconds: selectedHours * 3600 + selectedMinutes * 60,
                            importance: task.importance,
                            startDate: prefersTime ? startDate : nil,
                            endDate: prefersTime ? endDate : nil
                        )

                        onSave(updated)
                        dismiss()
                    }
                }
            }
            .onAppear {
                selectedHours = durationSeconds / 3600
                selectedMinutes = (durationSeconds % 3600) / 60
            }
        }
    }
}

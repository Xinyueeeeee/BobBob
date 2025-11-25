import SwiftUI

struct TaskDetailView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var taskStore: TaskStore
    @EnvironmentObject var scheduleVM: SchedulerViewModel

    @State var item: Task
    @State private var showEdit = false
    @State private var editSeconds: Int = 0

    /// Detects whether this looks like a Meal or an Activity based on the name.
    /// This was already in your original code – now we actually use it.  :contentReference[oaicite:1]{index=1}
    private var itemType: String {
        if item.name.lowercased().contains("meal") ||
            item.name.lowercased().contains("breakfast") ||
            item.name.lowercased().contains("lunch") ||
            item.name.lowercased().contains("dinner") {
            return "Meal"
        }

        if item.name.lowercased().contains("activity") ||
            item.name.lowercased().contains("gym") ||
            item.name.lowercased().contains("run") {
            return "Activity"
        }

        return "Task"
    }

    /// True if this task actually lives in TaskStore (normal task),
    /// false for the pseudo tasks created in `dailyFixedBlocks` for meals/activities.
    private var isStoredTask: Bool {
        taskStore.tasks.contains(where: { $0.id == item.id })
    }

    /// Convenience: is this a meal or activity block?
    private var isRoutineBlock: Bool {
        itemType == "Meal" || itemType == "Activity"
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // OVERDUE WARNING
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

                    // DATE / DEADLINE ROW
                    detailRow(
                        icon: "calendar",
                        title: isRoutineBlock ? "Date" : "Deadline",
                        value: isRoutineBlock
                            // Meals / Activities: date only
                            ? item.deadline.formatted(date: .abbreviated, time: .omitted)
                            // Normal tasks: date + time, as before
                            : item.deadline.formatted(date: .abbreviated, time: .shortened)
                    )

                    // DURATION
                    detailRow(
                        icon: "timer",
                        title: "Duration",
                        value: durationLabel(item.durationSeconds)
                    )

                    // TIME / PREFERRED TIME
                    if let start = item.startDate, let end = item.endDate {
                        detailRow(
                            icon: "clock",
                            title: isRoutineBlock ? "Time" : "Preferred Time",
                            value: isRoutineBlock
                                // Meals / Activities: time range only
                                ? "\(start.formatted(date: .omitted, time: .shortened)) → \(end.formatted(date: .omitted, time: .shortened))"
                                // Normal tasks: keep date + time as before
                                : "\(start.formatted(date: .abbreviated, time: .shortened)) → \(end.formatted(date: .abbreviated, time: .shortened))"
                        )
                    }

                    Spacer().frame(height: 120)
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Only show Edit/Delete for REAL tasks that live in TaskStore.
                    if isStoredTask {
                        Menu {
                            Button {
                                // Seed seconds for the editor; addTasksView will also override from existingTask.
                                editSeconds = item.durationSeconds
                                showEdit = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button(role: .destructive) {
                                deleteItem()
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title2)
                        }
                    }
                }
            }
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showEdit) {
            // Use the SAME editor as TasksView (addTasksView).
            addTasksView(
                totalSeconds: $editSeconds,
                onSave: { updated in
                    updateItem(updated)
                },
                existingTask: item
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    private func updateItem(_ updated: Task) {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == updated.id }) {
            taskStore.tasks[index] = updated
            item = updated
        } else {
            // If somehow it's not in the store, at least update the local copy.
            item = updated
        }
    }

    private func deleteItem() {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == item.id }) {
            taskStore.tasks.remove(at: index)
            dismiss()
        } else {
            // Pseudo task from calendar – nothing to delete in the store, just dismiss.
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

import SwiftUI

struct TasksView: View {
    @State private var showingAddSheet = false
    @State private var editingTask: Task? = nil
    @State private var editingTaskSeconds: Int = 0
    @ObservedObject private var taskStore = TaskStore.shared
    @State private var newTaskSeconds: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                background
                content
                
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)       
                    }
                }
            }

        }
        .sheet(isPresented: $showingAddSheet) {
            addTasksView(
                totalSeconds: $newTaskSeconds,
                onSave: { task in
                    taskStore.tasks.append(task)
                    newTaskSeconds = 0
                }
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
        .sheet(item: $editingTask) { taskToEdit in
            addTasksView(
                totalSeconds: $editingTaskSeconds,
                onSave: { updatedTask in
                    if let index = taskStore.tasks.firstIndex(where: { $0.id == updatedTask.id }) {
                        taskStore.tasks[index] = updatedTask
                    }
                },
                existingTask: taskToEdit
            )
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

private extension TasksView {
    var content: some View {
        VStack(spacing: 20) {

            if taskStore.tasks.isEmpty {
                ContentUnavailableView(
                        "No Tasks",
                        systemImage: "tray",
                        description: Text("Start by adding your first task.")
                    )
            }

            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach($taskStore.tasks) { $task in
                        taskRow(task: $task)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 10)
            }

            Spacer()
        }
    }
}

private extension TasksView {
    var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.blue.opacity(0.2),
                Color.blue.opacity(0.6)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}


private extension TasksView {
    func taskRow(task: Binding<Task>) -> some View {
        HStack(spacing: 14) {

            Button {
                task.isCompleted.wrappedValue.toggle()
            } label: {
                ReminderCircle(isCompleted: task.wrappedValue.isCompleted)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 4) {
                Text(task.wrappedValue.name)
                    .font(.headline)
                    .foregroundColor(task.wrappedValue.isCompleted ? .gray : .black)
                    .opacity(task.wrappedValue.isCompleted ? 0.5 : 1)

                Text("Due: \(task.wrappedValue.deadline.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption)
                    .foregroundColor(task.wrappedValue.isCompleted
                                     ? .gray.opacity(0.6)
                                     : .gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                editingTask = task.wrappedValue
                editingTaskSeconds = task.wrappedValue.durationSeconds
            }

            Button {
                deleteTask(task.wrappedValue)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
}

private extension TasksView {
    func deleteTask(_ task: Task) {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == task.id }) {
            taskStore.tasks.remove(at: index)
        }
    }
}






struct ReminderCircle: View {
    var isCompleted: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.9), lineWidth: 2)
                .frame(width: 22, height: 22)

            if isCompleted {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 22, height: 22)

                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

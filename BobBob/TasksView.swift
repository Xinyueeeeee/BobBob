import SwiftUI

struct TasksView: View {
    @ObservedObject private var taskStore = TaskStore.shared
    @State private var newTaskSeconds: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    
                    List {
                        ForEach($taskStore.tasks) { $task in
                            HStack(spacing: 14) {

                                // COMPLETION CIRCLE
                                Button {
                                    task.isCompleted.toggle()
                                } label: {
                                    ReminderCircle(isCompleted: task.isCompleted)
                                }
                                .buttonStyle(.plain)

                                // EVERYTHING ON THE RIGHT OPENS THE EDIT VIEW
                                NavigationLink {
                                    addTasksView(
                                        totalSeconds: $task.durationSeconds,
                                        onSave: { updated in task = updated },
                                        existingTask: task
                                    )
                                } label: {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(task.name)
                                            .font(.headline)
                                            .foregroundColor(task.isCompleted ? .gray : .black)
                                            .opacity(task.isCompleted ? 0.5 : 1)

                                        Text("Due: \(task.deadline.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption)
                                            .foregroundColor(task.isCompleted ? .gray.opacity(0.6) : .gray)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())  // ← Makes entire area tappable
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 6)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)

                    Spacer()
                }

                // ADD BUTTON (BOTTOM LEFT)
                NavigationLink(
                    destination: addTasksView(
                        totalSeconds: $newTaskSeconds,
                        onSave: { task in
                            taskStore.tasks.append(task)
                            newTaskSeconds = 0
                        },
                        existingTask: nil
                    )
                ) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.blue))
                        .frame(width: 60, height: 60)
                        .shadow(radius: 4)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Tasks")
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        taskStore.tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    TasksView()
}

struct ReminderCircle: View {
    var isCompleted: Bool

    var body: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(isCompleted ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 22, height: 22)

            // Inner dot when completed
            if isCompleted {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 15, height: 15)
            }
        }
    }
}

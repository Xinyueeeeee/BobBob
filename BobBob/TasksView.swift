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

                    Form {
                        ForEach($taskStore.tasks) { $task in
                            NavigationLink {
                                addTasksView(
                                    totalSeconds: $task.durationSeconds,
                                    onSave: { updatedTask in
                                        task = updatedTask   // update this task
                                    },
                                    existingTask: task
                                )
                            } label: {
                                Text(task.name)
                                    .font(.headline)
                                    .padding(.vertical, 8)
                            }
                        }
                        .onDelete(perform: deleteTask)
                    }
                    .scrollContentBackground(.hidden) // makes List transparent
                    .background(Color.clear)

                    Spacer()
                }
                .padding(.horizontal)

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
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding()

            }
            .navigationTitle("Tasks")
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        taskStore.tasks.remove(atOffsets: offsets)
    }
}

#Preview{
    TasksView()
}

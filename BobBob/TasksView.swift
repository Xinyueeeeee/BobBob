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
                            SwipeableCard(onDelete: {
                                deleteTask(task.wrappedValue)
                            }) {
                                HStack(spacing: 14) {

                                 
                                    Button {
                                        task.isCompleted.toggle()
                                    } label: {
                                        ReminderCircle(isCompleted: task.isCompleted)
                                    }
                                    .buttonStyle(.plain)

                                 
                                    NavigationLink {
                                        addTasksView(
                                            totalSeconds: $task.durationSeconds,
                                            onSave: { updated in
                                                task = updated
                                            },
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
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05),
                                        radius: 6, x: 0, y: 4)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)

                    Spacer()
                }

                
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
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottomLeading)
                .padding(.leading, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Tasks")
        }
    }


    private func deleteTask(_ task: Task) {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == task.id }) {
            taskStore.tasks.remove(at: index)
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
          
            Circle()
                .stroke(isCompleted ? Color.blue : Color.gray.opacity(0.5), lineWidth: 2)
                .frame(width: 22, height: 22)

    
            if isCompleted {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 15, height: 15)
            }
        }
    }
}
struct SwipeableCard<Content: View>: View {
    let content: Content
    let onDelete: () -> Void

    @GestureState private var dragOffset: CGFloat = 0
    @State private var revealDelete: Bool = false
    @State private var removed: Bool = false

    init(onDelete: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack(alignment: .trailing) {

            // DELETE BACKGROUND
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.red)
                    .frame(width: 80)
                    .overlay(
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
            }

            // MAIN CARD
            content
                .background(Color.white)
                .cornerRadius(14)
                .offset(x: removed ? -500 : (revealDelete ? -80 : 0) + dragOffset)
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            if value.translation.width < 0 {
                                state = value.translation.width
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                revealDelete = value.translation.width < -40
                            }
                        }
                )
                .onTapGesture {
                    if revealDelete {
                        withAnimation {
                            revealDelete = false
                        }
                    }
                }
                .animation(.easeOut, value: dragOffset)
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if revealDelete {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            removed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                            onDelete()
                        }
                    }
                }
        )
    }
}

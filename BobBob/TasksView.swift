import SwiftUI

struct TasksView: View {
    @ObservedObject private var taskStore = TaskStore.shared
    @State private var newTaskSeconds: Int = 0

    var body: some View {
        NavigationStack {
            ZStack {
                background
                content
                addButton
            }
            .navigationTitle("Tasks")
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
    var content: some View {
        VStack(spacing: 20) {

            // 🔥 Replaced LIST with ScrollView to REMOVE CLIPPING
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach($taskStore.tasks) { $task in
                        taskRow(task: $task)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.top, 10)
            }

            Spacer()
        }
    }
}

private extension TasksView {
    func taskRow(task: Binding<Task>) -> some View {
        SwipeableCard(onDelete: {
            deleteTask(task.wrappedValue)
        }) {

            HStack(spacing: 14) {

                // Completion Toggle
                Button {
                    task.isCompleted.wrappedValue.toggle()
                } label: {
                    ReminderCircle(isCompleted: task.wrappedValue.isCompleted)
                }
                .buttonStyle(.plain)

                // Tap to edit
                NavigationLink {
                    addTasksView(
                        totalSeconds: task.durationSeconds,
                        onSave: { updated in task.wrappedValue = updated },
                        existingTask: task.wrappedValue
                    )
                } label: {
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
                }
                .buttonStyle(.plain)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.05),
                    radius: 6, x: 0, y: 4)
        }
    }
}

private extension TasksView {
    func deleteTask(_ task: Task) {
        if let index = taskStore.tasks.firstIndex(where: { $0.id == task.id }) {
            taskStore.tasks.remove(at: index)
        }
    }
}

private extension TasksView {
    var addButton: some View {
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
}

struct SwipeableCard<Content: View>: View {
    let content: Content
    let onDelete: () -> Void

    @GestureState private var dragOffset: CGFloat = 0
    @State private var revealDelete: Bool = false
    @State private var removed: Bool = false
    @State private var cardHeight: CGFloat = 0

    init(onDelete: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.content = content()
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack(alignment: .trailing) {

            // DELETE BUTTON
            if revealDelete || dragOffset < 0 {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.red)
                    .frame(width: 70, height: cardHeight)
                    .overlay(
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
                    .transition(.opacity)
            }

            // MAIN CARD (measuring height)
            content
                .background(
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            cardHeight = geo.size.height
                        }
                    }
                )
                .cornerRadius(14)
                .offset(
                    x: removed ? -500 :
                        revealDelete ? -70 :
                        dragOffset
                )
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
                .contentShape(Rectangle())
                .animation(.easeOut, value: dragOffset)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 0)
        .simultaneousGesture(
            TapGesture().onEnded {
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

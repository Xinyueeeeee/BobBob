import SwiftUI

struct TaskDetailView: View {

    let item: Item   // or Task if you're using Task

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(item.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            HStack {
                Label("Deadline", systemImage: "calendar")
                Spacer()
                Text(item.deadline.formatted(date: .abbreviated, time: .shortened))
            }

            HStack {
                Label("Duration", systemImage: "clock")
                Spacer()
                Text("\(item.durationMinutes) mins")
            }

            HStack {
                Label("Importance", systemImage: "star.fill")
                Spacer()
                Text(String(item.importance))
            }

            if let start = item.startDate {
                HStack {
                    Label("Start allowed", systemImage: "arrow.right.circle")
                    Spacer()
                    Text(start.formatted(date: .abbreviated, time: .shortened))
                }
            }

            if let end = item.endDate {
                HStack {
                    Label("End allowed", systemImage: "arrow.left.circle")
                    Spacer()
                    Text(end.formatted(date: .abbreviated, time: .shortened))
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

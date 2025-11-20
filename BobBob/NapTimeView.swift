import SwiftUI
struct NapTimeView2: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var scheduleVM: SchedulerViewModel
    @Environment(\.dismiss) private var dismiss

    @AppStorage("sleepTime") private var sleepTime = Calendar.current.date(
        bySettingHour: 22, minute: 0, second: 0, of: Date()
    )!

    @AppStorage("wakeTime") private var wakeTime = Calendar.current.date(
        bySettingHour: 6, minute: 0, second: 0, of: Date()
    )!

    var body: some View {
        VStack {

            Text("What time do you go to sleep?")
                .font(.headline)
                .foregroundColor(.black.opacity(0.5))

            Spacer()

            DatePicker(
                "Select Time",
                selection: $sleepTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.bottom)
            .onChange(of: sleepTime) { _, _ in
                scheduleVM.refreshSchedule()
            }

            Text("What time do you wake up?")
                .font(.headline)
                .foregroundColor(.black.opacity(0.5))

            Spacer()

            DatePicker(
                "Select Time",
                selection: $wakeTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
            .onChange(of: wakeTime) { _, _ in
                scheduleVM.refreshSchedule()
            }

            Spacer()

            Text("Different people sleep at different hours.")
                .font(.footnote)
                .foregroundColor(.black.opacity(0.5))
        }
        .padding()
        .navigationTitle("Sleep Time")
    }
}

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
        ZStack(alignment: .bottomTrailing) {
            
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
           
            VStack(spacing: 16) {
                Spacer().frame(height: 80)
                VStack {
                    Text("What time do you go to sleep?")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.5))
                    
                    Spacer(minLength: 8)
                    
                    DatePicker(
                        "",
                        selection: $sleepTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .onChange(of: sleepTime) { _, _ in
                        scheduleVM.refreshSchedule()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4)
                
                
                VStack {
                    Text("What time do you wake up?")
                        .font(.footnote)
                        .foregroundColor(.black.opacity(0.5))
                    
                    Spacer(minLength: 8)
                    
                    DatePicker(
                        "",
                        selection: $wakeTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .onChange(of: wakeTime) { _, _ in
                        scheduleVM.refreshSchedule()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 4)
                
                Spacer(minLength: 120)
            }
            .padding()
            .navigationTitle("Sleep Time")
            
            
          
            
        }
    }
}

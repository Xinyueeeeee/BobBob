import SwiftUI

struct ChronotypeView2: View {
    @AppStorage("selectedChronotype") private var selectedChronotype: String?
    @Binding var hasSeenOnboarding: Bool
    
    @EnvironmentObject var prefsStore: PreferencesStore
    @EnvironmentObject var scheduleVM: SchedulerViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Text("What is your chronotype?")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.title3)
                    .bold()
                    .padding(.top)
                
                Button {
                    selectedChronotype = "Early Bird"
                    prefsStore.chronotype = "Early Bird"
                    scheduleVM.refreshSchedule()
                    scheduleVM.refreshNotifications()
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Early Bird")
                            .font(.headline)
                            .foregroundColor(selectedChronotype == "Early Bird" ? .white : .black)
                        
                        Text("You prefer starting your day earlier and feel most productive in the morning.")
                            .font(.subheadline)
                            .foregroundColor(selectedChronotype == "Early Bird"
                                             ? .white.opacity(0.9)
                                             : .black.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedChronotype == "Early Bird" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)
                
                Button {
                    selectedChronotype = "Night Owl"
                    prefsStore.chronotype = "Night Owl"
                    scheduleVM.refreshSchedule()    
                    scheduleVM.refreshNotifications()
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Night Owl")
                            .font(.headline)
                            .foregroundColor(selectedChronotype == "Night Owl" ? .white : .black)
                        
                        Text("You focus better later in the day and prefer working at night.")
                            .font(.subheadline)
                            .foregroundColor(selectedChronotype == "Night Owl"
                                             ? .white.opacity(0.9)
                                             : .black.opacity(0.7))
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedChronotype == "Night Owl" ? Color.blue : Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("Different people prefer working at different time periods.")
                    .font(.footnote)
                    .foregroundColor(.black.opacity(0.5))
            }
            .navigationTitle("Chronotype")
        }
    }
}

#Preview {
    ChronotypeView2(hasSeenOnboarding: .constant(false))
        .environmentObject(PreferencesStore.shared)
        .environmentObject(SchedulerViewModel())
}

//
//  AddRestActivitySheet.swift
//  BobBob
//
//  Created by Hanyi on 15/11/25.
//

import SwiftUI


struct RestActivityy: Identifiable {
    let id = UUID()
    var name: String
    var startDate: Date
    var endDate: Date
}

struct AddRestActivityView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var restActivities: [RestActivity]
    
    @State private var name: String = ""
   
    @State private var startDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var endDate: Date = Calendar.current.startOfDay(for: Date())
    
   
    private var isFormComplete: Bool {
        
        !name.isEmpty && startDate <= endDate
    }
    
    var body: some View {
        NavigationStack {
           
            Form {
              
                Section(header: Text("Activity name")) {
                    TextField("e.g., Vacation, Staycation, Sick Leave", text: $name)
                }
                
                Section(header: Text("REST PERIOD")) {
                    
                    DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    
                    DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                }
                
               
                Section {
                    Button("Save") {
                        let newActivity = RestActivity(name: name, startDate: startDate, endDate: endDate)
                        restActivities.append(newActivity)
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(!isFormComplete)
                }
            }
            .navigationTitle("Add Rest Day")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

struct AddRestActivityView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State var activities: [RestActivity] = []
        var body: some View {
            AddRestActivityView(restActivities: $activities)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}

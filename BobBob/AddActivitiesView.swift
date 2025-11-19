//
//  AddActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 15/11/25.
//
import SwiftUI
struct AddActivitiesView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var activities: [Activity]
    
    @State private var name: String = ""
    @State private var day: String = "Monday"
    @State private var regularity: String = "Weekly"
    @State private var time: Date = Date()
    @State private var duration: Int = 15
    
    let days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let regularOptions = ["Daily","Weekly","Monthly"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                   
                    Text("Activity Name").font(.headline)
                    TextField("e.g. Gym", text: $name)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    
                    Text("Day").font(.headline)
                    Picker("Day", selection: $day) {
                        ForEach(days, id: \.self) { day in
                            Text(day)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Text("Regularity").font(.headline)
                    Picker("Regularity", selection: $regularity) {
                        ForEach(regularOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    Text("Time").font(.headline)
                    DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    Section(header: Text("Duration (min)")) {
                        Stepper("\(duration) min", value: $duration, in: 5...120, step: 5)
                    }
                    
                    Button {
                        let newActivity = Activity(name: name, day: day, regularity: regularity, time: time)
                        activities.append(newActivity)
                        dismiss()
                    }label:{
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Add Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

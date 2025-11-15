//
//  AddRestActivitySheet.swift
//  BobBob
//
//  Created by Hanyi on 15/11/25.
//

import SwiftUI
struct AddRestActivityView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var restActivities: [RestActivity]
    
    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Activity Name").font(.headline)
                    TextField("Enter name", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    Text("Start Date").font(.headline)
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    Text("End Date").font(.headline)
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add Rest Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let newActivity = RestActivity(name: name, startDate: startDate, endDate: endDate)
                        restActivities.append(newActivity)
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(isFormComplete ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .disabled(!isFormComplete)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
    
    private var isFormComplete: Bool {
        !name.isEmpty && startDate <= endDate
    }
}

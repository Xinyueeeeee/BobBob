//
//  AddMealTimeView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//
import SwiftUI

struct AddMealTimeView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMeal: String = "Breakfast"
    @State private var mealTime: Date = Date()
    @State private var duration: Int = 15
    @State private var selectedMealTime: String? = nil
    
    let mealOptions = ["Breakfast", "Lunch", "Dinner"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Meal Type")) {
                    Picker("Select Meal", selection: $selectedMeal) {
                        ForEach(mealOptions, id: \.self) { meal in
                            Text(meal)
                        }
                    }
                }
                
                Section(header: Text("Time")) {
                    DatePicker("Meal Time", selection: $mealTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Duration (min)")) {
                    Stepper("\(duration) min", value: $duration, in: 5...120, step: 5)
                }
                
                Section{
                    Button{
                        dismiss()
                    }label:{
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }

            }
            .navigationTitle("Add Meal Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddMealTimeView()
}


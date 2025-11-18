//
//  AddMealTimeView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//
import SwiftUI

struct AddMealTimeView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMeal = "Breakfast"
    @State private var mealTime = Date()
    @State private var duration = 15
    
    let mealOptions = ["Breakfast", "Lunch", "Dinner", "Snack"]
    
    var onSave: (MealTime) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("MEAL TYPE")) {
                    Picker("Select Meal", selection: $selectedMeal) {
                        ForEach(mealOptions, id: \.self) { meal in
                            Text(meal)
                        }
                    }
                }
                
                Section(header: Text("TIME")) {
                    DatePicker("Meal Time", selection: $mealTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("DURATION (MIN)")) {
                    Stepper("\(duration) min", value: $duration, in: 1...60, step: 1)
                }
                Section {
                    Button("Save") {
                        onSave(
                            MealTime(mealType: selectedMeal,
                                     time: mealTime,
                                     duration: duration)
                        )
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Meal Time")
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            })
        }
    }
}

#Preview{
    AddMealTimeView { _ in }
}

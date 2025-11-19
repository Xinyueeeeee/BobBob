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
    @State private var durationHours: Int = 0
    @State private var durationMinutes: Int = 15
    
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
                
                Section(header: Text("DURATION")) {
                    HStack {
                    Picker("Hours", selection: $durationHours) {
                        ForEach(0..<24) { hour in
                            Text("\(hour) h")
                        }
                    }
                    .pickerStyle( .wheel)
                    .frame(maxWidth: .infinity)
                    
                    Picker("Minutes", selection: $durationMinutes) {
                        ForEach(0..<60) { min in
                            Text("\(min) m")
                        }
                    }
                    .pickerStyle( .wheel)
                }
                }
                
                Section {
                    Button("Save") {
                        let totalMinutes = durationHours * 60 + durationMinutes
                        
                        onSave(
                            MealTime(mealType: selectedMeal,
                                     time: mealTime,
                                     duration: totalMinutes)
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

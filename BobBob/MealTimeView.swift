//
//  MealTimeView.swift
//  BobBob
//
//  Created by minyi on 15/11/25.
//


import SwiftUI

struct MealTimeView2: View {
    @State private var selectedMeal: String? = nil
    @State private var breakfastTime = Date()
    @State private var lunchTime = Date()
    @State private var dinnerTime = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("When do you have your meals?")
                .font(.headline)
            
            Spacer()
            
            mealButton(title: "Breakfast", isSelected: selectedMeal == "Breakfast", time: $breakfastTime)
            mealButton(title: "Lunch", isSelected: selectedMeal == "Lunch", time: $lunchTime)
            mealButton(title: "Dinner", isSelected: selectedMeal == "Dinner", time: $dinnerTime)
            
            Spacer()
            
            Text("Different people eat at different hours.")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .navigationTitle("Meal Times")
    }
    
    @ViewBuilder
    private func mealButton(title: String, isSelected: Bool, time: Binding<Date>) -> some View {
        VStack(spacing: 5) {
            Button(action: {
                withAnimation {
                    selectedMeal = (selectedMeal == title) ? nil : title
                }
            }) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSelected ? Color.blue : Color.white)
                    .foregroundColor(isSelected ? .white : .black)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
            }
            
            if isSelected {
                VStack(spacing: 10) {
                    DatePicker(
                        "Select Time",
                        selection: time,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    
                    Button(action: {
                        print("\(title) saved: \(time.wrappedValue)")
                        selectedMeal = nil
                    }) {
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
                .padding(.horizontal)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    MealTimeView2()
}

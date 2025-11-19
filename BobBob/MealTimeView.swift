
import SwiftUI

struct MealTimeView2: View {
    @Binding var hasSeenOnboarding: Bool
    @ObservedObject var mealStore: MealTimeStore

    @State private var showingAddMeal = false
    @State private var editingMeal: MealTime? = nil

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomLeading) {

                VStack(spacing: 20) {

                    Text("When do you have your meals?")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.top)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(mealStore.meals) { meal in
                                Button {
                                    editingMeal = meal
                                } label: {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(meal.mealType)
                                            .font(.headline)
                                            .foregroundColor(.black)

                                        HStack {
                                            Label("\(meal.duration) min", systemImage: "timer")
                                            Label(
                                                meal.time.formatted(date: .omitted, time: .shortened),
                                                systemImage: "clock"
                                            )
                                        }
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white)
                                    .cornerRadius(14)
                                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer(minLength: 80)
                }

                Button {
                    showingAddMeal = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.leading, 25)
                .padding(.bottom, 30)
            }
            .navigationTitle("Meals")


            // ADD MODE
            .sheet(isPresented: $showingAddMeal) {
                AddMealTimeView(
                    meal: nil,
                    onSave: { newMeal in
                        mealStore.meals.append(newMeal)
                    }
                )
            }

            // EDIT MODE (reuse same view)
            .sheet(item: $editingMeal) { meal in
                AddMealTimeView(
                    meal: meal,
                    onSave: { updatedMeal in
                        if let index = mealStore.meals.firstIndex(where: { $0.id == updatedMeal.id }) {
                            mealStore.meals[index] = updatedMeal
                        }
                    }
                )
            }
        }
    }
}

#Preview {
    MealTimeView2(
        hasSeenOnboarding: .constant(false),
        mealStore: MealTimeStore()
    )
}


#Preview {
    MealTimeView2(hasSeenOnboarding: .constant(false), mealStore: MealTimeStore() )
}
//
//  MealTimeStore.swift
//  BobBob
//
//  Created by Hanyi on 19/11/25.
//



class MealTimeStore: ObservableObject {
    @Published var meals: [MealTime] = [] {
        didSet {
            saveMeals()
        }
    }
    
    private let storageKey = "savedMealTimes"
    
    init() {
        loadMeals()
    }
    
    func loadMeals() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        
        if let decoded = try? JSONDecoder().decode([MealTime].self, from: data) {
            self.meals = decoded
        }
    }
    
    func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}

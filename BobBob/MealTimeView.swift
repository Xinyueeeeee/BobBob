import SwiftUI

// MARK: - Enum to control sheet states
enum MealSheet: Identifiable {
    case add
    case edit(MealTime)

    var id: String {
        switch self {
        case .add: return "add"
        case .edit(let meal): return meal.id.uuidString
        }
    }
}

struct MealTimeView2: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var mealStore: MealTimeStore



    @State private var activeSheet: MealSheet? = nil   // <-- one sheet controller

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomLeading) {

                VStack(spacing: 20) {

                    Text("When do you have your meals?")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.top)
                        .padding(.horizontal, 20)


                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(mealStore.meals) { meal in
                                Button {
                                    activeSheet = .edit(meal)
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

                // ADD BUTTON — bottom-left

                Button {
                    activeSheet = .add
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding([.leading, .bottom], 25)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)


            // MARK: - ONE SHEET ONLY
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add:
                    AddMealTimeView(
                        meal: nil,
                        onSave: { newMeal in
                            mealStore.meals.append(newMeal)
                        }
                    )

                case .edit(let meal):
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
}


#Preview {
    MealTimeView2(hasSeenOnboarding: .constant(false))
        .environmentObject(MealTimeStore())
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

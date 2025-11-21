import SwiftUI

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
    
    @State private var activeSheet: MealSheet? = nil
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.2),
                        Color.blue.opacity(0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("When do you have your meals?")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.top)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            
                            ForEach(mealStore.meals) { meal in
                                mealRow(meal)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    Spacer(minLength: 80)
                }
                
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
                .padding(.leading, 25)
                .padding(.bottom, 25)
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .add:
                    AddMealTimeView(
                        meal: nil,
                        onSave: { new in mealStore.meals.append(new) }
                    )
                    
                case .edit(let meal):
                    AddMealTimeView(
                        meal: meal,
                        onSave: { updated in mealStore.updateMeal(updated) }
                    )
                }
            }
            .navigationTitle("Meal Time")
        }
    }
    func mealRow(_ meal: MealTime) -> some View {
        HStack {
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            Button {
                mealStore.deleteMeal(meal)
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
}


#Preview {
    MealTimeView2(hasSeenOnboarding: .constant(false))
        .environmentObject(MealTimeStore())
}

class MealTimeStore: ObservableObject {

    @Published var meals: [MealTime] = [] {
        didSet { saveMeals() }
    }

    private let storageKey = "savedMealTimes"

    init() {
        loadMeals()
    }

    private func loadMeals() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([MealTime].self, from: data) {
            self.meals = decoded
        }
    }

    private func saveMeals() {
        if let encoded = try? JSONEncoder().encode(meals) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    func addMeal(_ meal: MealTime) {
        meals.append(meal)
    }

    func updateMeal(_ updated: MealTime) {
        if let i = meals.firstIndex(where: { $0.id == updated.id }) {
            meals[i] = updated
        }
    }

    func deleteMeal(_ meal: MealTime) {
        if let i = meals.firstIndex(where: { $0.id == meal.id }) {
            meals.remove(at: i)
        }
    }

}

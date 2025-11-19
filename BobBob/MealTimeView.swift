import SwiftUI
struct MealTimeView2: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var mealTimes: [MealTime] = []
    @State private var showingAddMeal = false
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 20) {
                    
                    Text("When do you have your meals?")
                        .font(.headline)
                        .foregroundColor(.black)
                        .opacity(0.5)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(mealTimes) { meal in
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    Text(meal.mealType)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    HStack {
                                        Label("\(meal.duration) min", systemImage: "timer")
                                        Label(meal.time.formatted(date: .omitted, time: .shortened),
                                              systemImage: "clock")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                                .shadow(color: .black.opacity(0.05),
                                        radius: 6,
                                        x: 0,
                                        y: 4)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        
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
                        
                        Spacer()
                        
                        NavigationLink {
                            ActivitiesView(hasSeenOnboarding: $hasSeenOnboarding)
                        } label: {
                            Text("Next")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .navigationTitle("Meals")
                .sheet(isPresented: $showingAddMeal) {
                    AddMealTimeView { newMeal in
                        mealTimes.append(newMeal)
                    }
                }
            }
        }
    }



#Preview {
    MealTimeView2(hasSeenOnboarding: .constant(false))
}

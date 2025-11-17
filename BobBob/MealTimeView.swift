import SwiftUI
struct MealTimeView2: View {
    @State private var showingAddMeal = false
    
    var body: some View {
        VStack {
            Text("When do you have your meals?")
                .font(.headline)
                .foregroundColor(.black).opacity(0.5)
            
            Spacer()
            
            HStack {
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
                    ActivitiesView()
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
        .sheet(isPresented: $showingAddMeal) {
            AddMealTimeView()
        }
        .navigationTitle("Meal Time")
    }
}


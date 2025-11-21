//
//  RestActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//

import SwiftUI

struct RestDaysView2: View {
    @Binding var hasSeenOnboarding: Bool
    @EnvironmentObject var restStore: RestActivityStore

    @State private var showingAddSheet = false
    @State private var editingActivity: RestActivity? = nil

    var body: some View {
        NavigationStack {
            ZStack {

                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    Text("When do you rest?")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))
                        .padding(.top)

                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            ForEach(restStore.activities) { activity in
                                restRow(activity: activity)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 10)
                    }

                    Spacer(minLength: 80)
                }
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            showingAddSheet = true
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
                        Spacer()
                    }
                }
            }
            .navigationTitle("Rest Days")
            .sheet(isPresented: $showingAddSheet) {
                AddRestActivityView(activity: nil) { new in
                    restStore.activities.append(new)
                }
            }
            .sheet(item: $editingActivity) { activity in
                AddRestActivityView(activity: activity) { updated in
                    if let i = restStore.activities.firstIndex(where: { $0.id == updated.id }) {
                        restStore.activities[i] = updated
                    }
                }
            }
        }
    }
}

private extension RestDaysView2 {

    
    func restRow(activity: RestActivity) -> some View {
        HStack {
            Button {
                editingActivity = activity
            } label: {
                VStack(alignment: .leading, spacing: 6) {

                    Text(activity.name)
                        .font(.headline)
                        .foregroundColor(.black)

                    HStack {
                        Label(
                            activity.startDate.formatted(date: .abbreviated, time: .omitted),
                            systemImage: "sunrise"
                        )
                        Label(
                            activity.endDate.formatted(date: .abbreviated, time: .omitted),
                            systemImage: "sunset"
                        )
                    }
                    .font(.subheadline)
                    .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            Button {
                deleteActivity(activity)
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


    func deleteActivity(_ activity: RestActivity) {
        if let i = restStore.activities.firstIndex(where: { $0.id == activity.id }) {
            restStore.activities.remove(at: i)
        }
    }
}



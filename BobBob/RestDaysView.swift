//
//  RestActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//

import SwiftUI

struct RestDaysView2: View {

    @EnvironmentObject var restStore: RestActivityStore
    @Binding var hasSeenOnboarding: Bool
    @State private var showingAddSheet = false
    @State private var editingActivity: RestActivity? = nil

    var body: some View {
        NavigationStack {
                VStack(spacing: 20) {

                    Text("When do you rest?")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.5))

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {

                            ForEach(restStore.activities) { activity in
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
                                        if let i = restStore.activities.firstIndex(where: { $0.id == activity.id }) {
                                            restStore.activities.remove(at: i)
                                        }
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
                                .shadow(color: .black.opacity(0.05),
                                        radius: 6, x: 0, y: 4)
                            }

                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    Spacer(minLength: 40)
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
            .navigationTitle("Rest Days")

            .sheet(isPresented: $showingAddSheet) {
                AddRestDaysPickerView(existing: nil) { newActivity in
                    restStore.activities.append(newActivity)
                }
            }

            .sheet(item: $editingActivity) { activity in
                AddRestDaysPickerView(existing: activity) { updated in
                    if let i = restStore.activities.firstIndex(where: { $0.id == updated.id }) {
                        restStore.activities[i] = updated
                    }
                }
            }
        }
    }
}

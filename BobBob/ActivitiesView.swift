//
//  ActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//


import SwiftUI

struct ActivitiesView2: View {
    @State private var activities: [Activity] = []
    @State private var showingAddActivity = false
    @Binding var hasSeenOnboarding: Bool
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Text("Do you have any recurring activities?")
                    .font(.headline)
                    .foregroundColor(.black).opacity(0.5)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(activities) { activity in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(activity.name)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                HStack {
                                    Label(activity.day, systemImage: "calendar")
                                    Label(activity.regularity, systemImage: "repeat")
                                    Label(activity.timeFormatted, systemImage: "clock")
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
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                Spacer()
                HStack(spacing: 20) {
                    Button {
                        showingAddActivity = true
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
                    NavigationLink{
                        SettingsView(hasSeenOnboarding: $hasSeenOnboarding)
                    }label: {
                        Text("Save")
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
        }
        .navigationTitle("Activites")
        .sheet(isPresented: $showingAddActivity) {
            AddActivitiesView(activities: $activities)
        }
    }
}



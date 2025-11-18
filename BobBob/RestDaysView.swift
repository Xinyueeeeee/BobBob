//
//  RestActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//

import SwiftUI
struct RestDaysView2: View {
    @State private var restActivities: [RestActivity] = []
    @State private var showingAddSheet = false
    
    var body: some View {
            NavigationStack {
                VStack(spacing: 20) {
                    
                    Text("When do you rest?")
                        .font(.headline)
                        .foregroundColor(.black).opacity(0.5)
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(restActivities) { activity in
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
                        
                        Spacer()
                        
                      NavigationLink{
                          SettingsView()
                        } label: {
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
            .navigationTitle("Rest Days")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddSheet) {
                AddRestActivityView(restActivities: $restActivities)
            }
        }
    }




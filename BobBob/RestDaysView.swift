//
//  RestActivitiesView.swift
//  BobBob
//
//  Created by Hanyi on 17/11/25.
//

import SwiftUI
struct RestDaysView2: View{
    @State private var restActivities: [RestActivity] = []
    @State private var showingAddSheet = false
    @State private var selectedRestActivities: String? = nil
    
    var body: some View {
            VStack(spacing: 0) {
                Text("When do you rest?")
                    .font(.headline)
                    .foregroundColor(.gray)
                HStack {
                    Text("Activity Name").bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("Start Date").bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("End Date").bold().frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                
                Divider()
                
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(restActivities) { activity in
                            HStack {
                                Text(activity.name).frame(maxWidth: .infinity, alignment: .leading)
                                Text(activity.startDate, style: .date).frame(maxWidth: .infinity, alignment: .leading)
                                Text(activity.endDate, style: .date).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .shadow(color: .gray.opacity(0.1), radius: 1, x: 0, y: 1)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                HStack {
                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    
                    Spacer()
                    NavigationLink(destination: settingsView())
                    {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(selectedRestActivities == nil ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
                .disabled(selectedRestActivities == nil)
                .padding()
            }
            .navigationTitle("Rest Days")
            .sheet(isPresented: $showingAddSheet) {
                AddRestActivityView(restActivities: $restActivities)
            }
        }
    }


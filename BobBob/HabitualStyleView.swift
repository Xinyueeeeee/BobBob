//
//  HabitualStyleView.swift
//  BobBob
//
//  Created by minyi on 15/11/25.
//

import SwiftUI

struct HabitualStyleView2: View {
    @State private var selectedStyle: String? = nil
    
    var body: some View {
            NavigationStack{
            
                    
                VStack(spacing: 30) {
                    
                    Text("What is your habitual style?")
                        .foregroundColor(.gray)
                        .font(.title3)
                        .bold()
                        .padding(.top)
                    
                    
                    Button(action: {
                        selectedStyle = "Hopper"
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hopper")
                                .font(.headline)
                                .foregroundColor(selectedStyle == "Hopper" ? .white : .black)
                            
                            Text("Someone who usually focuses for short bursts of time and prefers breaking activities into multiple sessions.")
                                .font(.subheadline)
                                .foregroundColor(selectedStyle == "Hopper" ? .white.opacity(0.9) : .black.opacity(0.7))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedStyle == "Hopper" ? Color.blue : Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                    }
                    .padding(.horizontal)
                    
                    
                    
                    Button(action: {
                        selectedStyle = "Hyperfocus"
                    }) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Hyperfocus")
                                .font(.headline)
                                .foregroundColor(selectedStyle == "Hyperfocus" ? .white : .black)
                            
                            Text("Someone who prefers focusing for longer periods of time and can finish tasks in a single session.")
                                .font(.subheadline)
                                .foregroundColor(selectedStyle == "Hyperfocus" ? .white.opacity(0.9) : .black.opacity(0.7))
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedStyle == "Hyperfocus" ? Color.blue : Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                    }
                    .padding(.horizontal)
                    
                    
                    Spacer()
                    
                    Text("Different people have different working styles.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: settingsView()) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(selectedStyle == nil ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(selectedStyle == nil)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    
                }
                .navigationTitle("Habitual Style")
            }
        }
    }

#Preview {
    HabitualStyleView2()
}

//
//  ChronotypeView.swift
//  BobBob
//
//  Created by minyi on 15/11/25.
//

import SwiftUI

struct ChronotypeView2: View {
    @State private var selectedChronotype: String? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("What is your chronotype?")
                .foregroundColor(.gray)
                .font(.title3)
                .bold()
                .padding(.top)
            
            Button(action: {
                selectedChronotype = "Early Bird"
            }) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Early Bird")
                        .font(.headline)
                        .foregroundColor(selectedChronotype == "Early Bird" ? .white : .black)
                    
                    Text("You prefer starting your day earlier and feel most productive in the morning.")
                        .font(.subheadline)
                        .foregroundColor(selectedChronotype == "Early Bird" ? .white.opacity(0.9) : .black.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(selectedChronotype == "Early Bird" ? Color.blue : Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4)
            }
            .padding(.horizontal)
            
            Button(action: {
                selectedChronotype = "Night Owl"
            }) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Night Owl")
                        .font(.headline)
                        .foregroundColor(selectedChronotype == "Night Owl" ? .white : .black)
                    
                    Text("You focus better later in the day and prefer working at night.")
                        .font(.subheadline)
                        .foregroundColor(selectedChronotype == "Night Owl" ? .white.opacity(0.9) : .black.opacity(0.7))
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(selectedChronotype == "Night Owl" ? Color.blue : Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4)
            }
            .padding(.horizontal)
            Spacer()

            Text("Different people have different working styles.")
                .font(.footnote)
                .foregroundColor(.gray)

        }
        .navigationTitle("Chronotype")
    }
}

#Preview {
    ChronotypeView2()
}


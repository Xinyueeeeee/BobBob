//
//  HabitualStyleView.swift
//  BobBob
//
//  Created by minyi on 15/11/25.
//

import SwiftUI

struct HabitualStyleView2: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var selectedStyle: String? = nil
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 30) {

            Text("What is your habitual style?")
                .foregroundColor(.black.opacity(0.5))
                .font(.title3)
                .bold()
                .padding(.top)

            // Hopper
            Button {
                selectedStyle = "Hopper"
            } label: {
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

            // Hyperfocus
            Button {
                selectedStyle = "Hyperfocus"
            } label: {
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
                .foregroundColor(.black.opacity(0.5))

            Button {
                dismiss()   // ← go back to SettingsView
            } label: {
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
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)

        }
        .navigationTitle("Habitual Style")
    }
}

#Preview {
    HabitualStyleView2(hasSeenOnboarding: .constant(false))
}

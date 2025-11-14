//
//  TasksView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct TasksView: View {
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .navigationTitle(Text("Tasks"))
                VStack {
                    
                }
            }
        }
    }
}
struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Welcome to the Sheet!")
                .font(.title)
                .padding()
            
            Button("Done") {
                dismiss()
            }
        }
    }
}
#Preview {
    TasksView()
}

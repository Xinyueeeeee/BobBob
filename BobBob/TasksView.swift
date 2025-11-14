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
        ZStack {
            Color.blue.opacity(0.3)
                .ignoresSafeArea()
                .navigationTitle(Text("Tasks"))
                VStack {
                    Button(action: {
                        print("Circular button tapped!")
                    }) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(Color.blue)
                            )
                            .frame(width: 60, height: 60)
                    }
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

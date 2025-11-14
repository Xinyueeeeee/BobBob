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
            VStack {
                HStack {
                    Text("Tasks")
                        .bold()
                        .font(.largeTitle)
                    Spacer()
                }
                Spacer()
                Button("Show Sheet") {
                    showingSheet.toggle()
                }
            }
            .sheet(isPresented: $showingSheet) {
                SheetView()
            }
            .padding()
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
    #Preview {
        TasksView()
    }
}

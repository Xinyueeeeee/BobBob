//
//  TasksView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct TasksView: View {
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
                }
            .padding()
        }
    }
}

#Preview {
    TasksView()
}

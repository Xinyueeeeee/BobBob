//
//  NapTimeView.swift
//  BobBob
//
//  Created by minyi on 15/11/25.
//

import SwiftUI

struct NapTimeView2: View {
    @State private var sleepTime = Date()
    
    var body: some View {
        VStack {
            Text("What time do you go to sleep?")
                .font(.headline)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text("Sleep Time")
                .font(.headline)
                .foregroundColor(.gray)
            
            DatePicker(
                "Select Time",
                selection: $sleepTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            Text("Wake Up Time")
                .font(.headline)
                .foregroundColor(.gray)
            
            DatePicker(
                "Select Time",
                selection: $sleepTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            
            Spacer()
            
            Text("Different people sleep at different hours.")
                .font(.footnote)
                .foregroundColor(.gray)

        }
        .padding()
        .navigationTitle("Sleep Time")
    }
}

#Preview {
    NapTimeView2()
}

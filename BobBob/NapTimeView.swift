//
//  NapTimeView.swift
//  BobBob
//
//  Created by minyi on 15/11/25.
//

import SwiftUI

    struct NapTimeView2: View {
        @AppStorage("sleepTime") private var sleepTime = Calendar.current.date(bySettingHour: 22, minute: 0, second: 0, of: Date())!
        @AppStorage("wakeTime") private var wakeTime = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!

    
    var body: some View {
            VStack {
                Text("What time do you go to sleep?")
                    .font(.headline)
                    .foregroundColor(.black).opacity(0.5)
                
                Spacer()
                
                DatePicker(
                    "Select Time",
                    selection: $sleepTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.bottom)
                
                Text("What time do you wake up?")
                    .font(.headline)
                    .foregroundColor(.black).opacity(0.5)
                   
                  
                Spacer()
                
                DatePicker(
                    "Select Time",
                    selection: $wakeTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding()
                
                Spacer()
                
                Text("Different people sleep at different hours.")
                    .font(.footnote)
                    .foregroundColor(.black).opacity(0.5)
                
                NavigationLink {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .padding()
            .navigationTitle("Sleep Time")
        }
    }

#Preview {
    NapTimeView2()
}

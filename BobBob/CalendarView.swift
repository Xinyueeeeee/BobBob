//
//  CalendarView.swift
//  BobBob
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var color: Color = .blue
    @State private var date = Date.now
    let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack {
            LabeledContent("Calendar Color") {
                ColorPicker("", selection: $color, supportsOpacity: false)
            }
            LabeledContent("Date/Time") {
                DatePicker("", selection: $date)
            }
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) {index in
                    Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
                LazyVGrid(columns: columns, content: {
                }
                )
                
                .padding()
            }
        }
        
        
    }
    
}

#Preview {
    CalendarView()
}

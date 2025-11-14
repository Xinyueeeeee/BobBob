//
//  ContentView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
           
        }
      
    }
}
struct IntroductionScreenView : View {
    let title : String
    let description : String
    let imageName : String
    let isLastPage : Bool
    
    
    var body : some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
        Text(description)
            .font(.body)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        
        if isLastPage {
            Button(action: {
                
            }){
                Text("Get Started!")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        
    }
    
    #Preview {
        ContentView()
    }
}

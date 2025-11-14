//
//  Onboarding.swift
//  BobBob
//
//  Created by Hanyi on 14/11/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView{
        //eg
            //IntroductionScreenView(title: <#T##String#>, description: <#T##String#>, imageName: <#T##String#>, isLastPage: <#T##Bool#>)
       //page1
            //IntroductionScreenView(title: "Welcome", description: "A task organiser that adapts to the way you acually work", imageName: <#T##String#>, isLastPage: false)
            
            //IntroductionScreenView(title: <#T##String#>, description: <#T##String#>, imageName: <#T##String#>, isLastPage: <#T##Bool#>)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
struct IntroductionScreenView : View {
    let title : String
    let description : String
    let imageName : String
    let isLastPage : Bool
    @State private var isSheetPresented = false
    
    var body : some View {
        VStack {
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
                Button {
                    
                } label: {
                    Text("Get Started!")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .frame(minWidth:0,maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(color:Color.black.opacity(0.3),radius: 5, x:0,y:3)
                }
                
                
                
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isSheetPresented, content:{
            LandingScreen()
        } )
    }
}

#Preview {
    OnboardingView()
}

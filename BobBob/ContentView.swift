//
//  ContentView.swift
//  BobBob
//
//  Created by Huang Qing on 14/11/25.
//

import SwiftUI

struct ContentView: View {
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


#Preview {
    ContentView()
}

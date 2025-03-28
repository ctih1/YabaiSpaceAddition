//
//  ContentView.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 26.3.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            
            Text("Yabai spaces integration with the top bar")
                .navigationTitle("Yabai  Space Addition")
            
            HStack {
                Button("Open settings") {
                    print("Implement later xd")
                }
                Button("Quit") {
                    exit(0)
                } 
            }
        }
        
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

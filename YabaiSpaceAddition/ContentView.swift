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
               
            Button("Kill me") {
                do {
                    let manager = try SpaceManager()
                    let amount = manager.getNumberOfSpaces()
                    let labels = manager.getSpaceNames()
                    let focused = manager.getFocusedSpace()
                    
                    print("Amount: \(amount) Focused: \(focused) labels: \(labels)")
                } catch let error {
                    print(error)
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

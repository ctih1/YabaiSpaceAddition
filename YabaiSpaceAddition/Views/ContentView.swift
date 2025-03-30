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
                    SettingsView().openWindow()
                }
                Button("Quit") {
                    exit(0)
                } 
            }
            Button("Refresh top bar") {
                AppDelegate.instance.topBarManager.refresh()
            }
        }
    
        
        .padding()
    }
    
    func openSettings() {
       
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

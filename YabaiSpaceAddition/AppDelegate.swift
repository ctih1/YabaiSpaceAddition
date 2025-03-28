//
//  AppDelegate.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 26.3.2025.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var topBarManager: TopBarManager!
    var spaceManager: SpaceManager!
    var sockListener: SockListener!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do {
            spaceManager = try SpaceManager()
            
            topBarManager = TopBarManager(spaceManager: spaceManager)
            sockListener = SockListener(topBarManager: topBarManager)
            let queue = DispatchQueue(label: "Socket scanner")
            queue.async {
                self.sockListener.scanner()
            }
        } catch let error {
            print(error)
        } 

    }
}

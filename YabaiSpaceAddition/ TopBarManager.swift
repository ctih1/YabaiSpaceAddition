//
//   TopBarManager.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 26.3.2025.
//

import Foundation
import AppKit

let defaultSpaceName = "Untitled"

class TopBarManager {
    var topBarItem: NSStatusItem!
    var topBarItems: [NSStatusItem] = []
    var buttons: [NSStatusBarButton?] = []
    var spaceManager: SpaceManager;
    var spaceCount: Int
    var spaceLabels: Dictionary<UInt8, String>
    var focusedId: UInt8
    
    
    init(spaceManager: SpaceManager) {
        self.spaceManager = spaceManager
        (self.spaceCount, self.spaceLabels, self.focusedId) = TopBarManager.getSpacemanagerVars(spaceManager: spaceManager)
        setupTopBar()
    }
    
    static func getSpacemanagerVars(spaceManager: SpaceManager) -> (Int, Dictionary<UInt8,String>, UInt8) {
        let spaceCount: Int = spaceManager.getNumberOfSpaces()
        let spaceLabels: Dictionary<UInt8, String> = spaceManager.getSpaceNames()
        let focusedId: UInt8 = spaceManager.getFocusedSpace()
        
        return (spaceCount, spaceLabels, focusedId)
    }
    
    private func setupTopBar() {
        let topBar = NSStatusBar.system
        
        for i in 1...spaceCount {
            let topItem = topBar.statusItem(withLength: NSStatusItem.variableLength)
            topItem.button?.title = " \(i) - \(spaceLabels[UInt8(i)] ?? defaultSpaceName)"
            topItem.button?.isTransparent = false
            topItem.button?.wantsLayer = true
            topItem.button?.layer?.cornerRadius = 4
            topItem.button?.layer?.backgroundColor = NSColor.black.cgColor
            
            if i == focusedId {
                topItem.button?.layer?.backgroundColor = NSColor.white.cgColor
            }

            buttons.append(topItem.button);
            topBarItems.append(topItem) ;
        }
    }
    
    public func refresh() {
        print("Refreshing...")
        do {
            try spaceManager.refreshVars();
        } catch let error {
            print(error)
        }
        
        (self.spaceCount, self.spaceLabels, self.focusedId) = TopBarManager.getSpacemanagerVars(spaceManager: spaceManager)
        
        for (index, item) in topBarItems.enumerated() {
            DispatchQueue.main.async {
                if index + 1 == self.focusedId {
                    item.button?.layer?.backgroundColor = NSColor.white.cgColor
                    item.button?.font = NSFont.systemFont(ofSize: 16, weight: .bold)
                    item.button?.attributedTitle = NSAttributedString(string: item.button?.title ?? "Unknown", attributes: [.foregroundColor: NSColor.black])
                } else {
                    item.button?.layer?.backgroundColor = NSColor.black.cgColor
                    item.button?.attributedTitle = NSAttributedString(string: item.button?.title ?? "Unknown", attributes: [.foregroundColor: NSColor.white])
                }
            }
        }
       
        
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

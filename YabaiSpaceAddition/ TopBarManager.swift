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
            
            topItem.button?.wantsLayer = true
            styleInactive(button: topItem.button!)
            if i == focusedId {
                styleActive(button: topItem.button!)
            }

            buttons.append(topItem.button)
            topBarItems.append(topItem)
        }
    }
    
    private func styleActive(button: NSStatusBarButton) {
        button.image?.isTemplate = true
        button.font = NSFont.systemFont(ofSize: 16, weight: .bold)
        button.attributedTitle = NSAttributedString(string: button.title, attributes: [.foregroundColor: NSColor.controlAccentColor])
    }
    
    private func styleInactive(button: NSStatusBarButton) {
        button.font = NSFont.systemFont(ofSize: 13, weight: .regular)
        button.attributedTitle = NSAttributedString(string: button.title, attributes: [.foregroundColor: NSColor.white])
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
                    self.styleActive(button: item.button!)
                } else {
                    self.styleInactive(button: item.button!)
                }
            }
        }
       
        
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

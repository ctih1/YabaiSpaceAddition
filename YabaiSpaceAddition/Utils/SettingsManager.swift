//
//  SettingsManager.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 29.3.2025.
//

import Foundation

class SettingsManager {
    init() {
        
    }
    
    private let defaults = UserDefaults.standard
    
    var emojis: Bool {
        get { return defaults.value(forKey: "emojisToggled") as? Bool ?? false }
        set { defaults.set(newValue, forKey: "emojisToggled") }
    }
    
    var emojiKeys: Dictionary<String,String> {
        get { return emojis ? defaults.object(forKey: "emojiKeys") as? [String:String] ?? [:] : [:] }
        set { defaults.set(newValue, forKey: "emojiKeys") }
    }
    
    var unfocusedFontSize: Int {
        get { print(" getrting unfocused"); return defaults.value(forKey: "fontSizeUnfocused") as? Int ?? 12 }
        set { print("Setting unfocused");  defaults.set(newValue, forKey: "fontSizeUnfocused") }
    }
    
    var focusedFontSize: Int {
        get { return defaults.value(forKey: "fontSizeFocused") as? Int ?? 14 }
        set { defaults.set(newValue, forKey: "fontSizeFocused") }
    }

}

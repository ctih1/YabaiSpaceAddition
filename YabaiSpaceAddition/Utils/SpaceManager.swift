//
//  SpaceManager.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 26.3.2025.
//

import Foundation

let yabaiPath:String = "/usr/local/bin/yabai"
let yabaiCommand:String = "\(yabaiPath) -m query --spaces"

class SpaceManager {
    var jsonData: [YabaiCommandOutput]
    
    enum SpaceError: Error {
        case JsonError(String)
    }
    
    struct YabaiCommandOutput: Codable {
        var id: Int32
        var uuid: String?
        var index: UInt8
        var label: String
        var type: String
        var display: UInt8
        var windows: [UInt32]
        var firstwindow: UInt32
        var lastwindow: UInt32
        var hasfocus: Bool
        var isvisible: Bool
        var isnativefullscreen: Bool
        
        
        enum CodingKeys: String, CodingKey {
            case id
            case uuid
            case index
            case label
            case type
            case display
            case windows
            case firstwindow = "first-window"
            case lastwindow = "last-window"
            case hasfocus = "has-focus"
            case isvisible = "is-visible"
            case isnativefullscreen = "is-native-fullscreen"
        }
    }
    
    init() throws {
        self.jsonData = SpaceManager.variableGetter()
    }
    
    private static func variableGetter() -> [YabaiCommandOutput] {
        let commandOutput: String = SpaceManager.runCommand(command: yabaiCommand)
        let decoder = JSONDecoder()
        let jsonData: [YabaiCommandOutput]
        
        do {
            jsonData = try decoder.decode([YabaiCommandOutput].self,from: commandOutput.data(using: .utf8)!)
            return jsonData
        } catch let error {
            print(error)
            return []
        }
        
    }
    
    public func refreshVars() throws -> () {
        self.jsonData =  SpaceManager.variableGetter()
        if jsonData.count == 0 {
            throw SpaceError.JsonError("JSON decode failed")
        }
        
    }
 
    public func getNumberOfSpaces() -> Int {
        /// Gets the number of spaces (aka virtual desktops) currently in use.
    
        ///
            
        return jsonData.count

    }
    
    public func getSpaceNames() -> Dictionary<UInt8, String> {
        var spaces: Dictionary<UInt8,String> = Dictionary()
        jsonData.forEach { space in
            spaces[space.index] = space.label
        }
        
        return spaces
    }
    
    public func getFocusedSpace() -> UInt8 {
        var targetSpace: UInt8 = 0
        
        jsonData.forEach { space in
            if space.hasfocus {
                targetSpace = space.index
            }
        }
        return targetSpace
    }
    
    private static func runCommand(command: String) -> String {
        let task = Process();
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c",  command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        print(output)

        return output
    }
}


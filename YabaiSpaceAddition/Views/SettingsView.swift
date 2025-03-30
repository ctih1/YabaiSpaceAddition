//
//  SettingsView.swift
//  YabaiSpaceAddition
//
//  Created by Onni Nevala on 29.3.2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
            GeneralTabView()
                .tabItem {
                    Text("General")
                }
            EmojiTabView()
                .tabItem {
                    Text("Emoji")
                }
        }
        .padding()
    }
}

extension View {
    private func newWindow() -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 400, height: 600),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered, defer: false
        )
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        return window
    }
    func openWindow() {
        self.newWindow().contentView = NSHostingView(rootView: self)
    }
}

struct GeneralTabView: View {
    @State private var isEmojiOn: Bool = SettingsManager().emojis
    @State private var unfocusedFontSize: Int = SettingsManager().unfocusedFontSize
    @State private var focusedFontSize: Int = SettingsManager().focusedFontSize
    
    @State private var test : Double = 0.0
    
    var unfocusedFontSizeProxy: Binding<Double>{
            Binding<Double>(get: {
                return Double(unfocusedFontSize)
            }, set: {
                
                unfocusedFontSize = Int($0)
                SettingsManager().unfocusedFontSize = Int($0)
            })
    }
    
    var focusedFontSizeProxy: Binding<Double>{
            Binding<Double>(get: {
                return Double(focusedFontSize)
            }, set: {
                focusedFontSize = Int($0)
                SettingsManager().focusedFontSize = Int($0)
            })
    }
    
    
    var body: some View {
        ScrollView {
            VStack {
                Toggle(isOn: $isEmojiOn) {
                    Text("Turn on space emojis")
                }
                    .help("Allows you to set emojis for each space")
                    .onChange(of: isEmojiOn) { newValue in
                        SettingsManager().emojis = newValue
                    }
                    .toggleStyle(.switch)
                Divider()
                
                Section {
                    Text("Unfocused space font size").font(.title3)
                    TextField("Default: 12", value: $unfocusedFontSize, format: .number)
                    Slider(value: unfocusedFontSizeProxy, in: 6.0...24.0, step: 1.0)
                }.padding()
                
                Section {
                    Text("Focused space font size").font(.title3)
                    TextField("Default: 14", value: $focusedFontSize, format: .number)
                    Slider(value: focusedFontSizeProxy, in: 6.0...24.0, step: 1.0)
                }.padding()


                
            }
        }
    }
}

struct EmojiTabView: View {
    @State private var remappedLabels = try! SpaceManager().getSpaceNames().map { (key,value) in return (value,SettingsManager().emojiKeys[String(value)] ?? "") }

    let spaceAmount: Int = try! SpaceManager().getNumberOfSpaces()
    let spaceLabels = try! SpaceManager().getSpaceNames()
    
    var body: some View {

        VStack {
            ScrollView {
                ForEach($remappedLabels, id: \.0) { $item in
                    Text("\(item.0)")
                    TextField(
                        "Emoji",
                        text: $item.1
                    )
                    .padding(.trailing, 16)
                    .autocorrectionDisabled(true)
                    
                }
                
                Button("save") {
                    saveEmojiSelections(remappedLabels: remappedLabels)
                }.buttonStyle(.automatic)
            }

        }
    }
    
    
}

private func saveEmojiSelections(remappedLabels: [(String,String)]) {
    let currentKeys = SettingsManager().emojiKeys
    
    let newSettings = remappedLabels.map {(key,value) in return (key,value != "" ? value: currentKeys[key] ?? "" )}
    
    SettingsManager().emojiKeys = Dictionary(uniqueKeysWithValues: newSettings);
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        
    }
}

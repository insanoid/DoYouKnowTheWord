//
//  AppDelegate.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 15/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_: Notification) {
        let contentView = ContentView()
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: .zero,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )

        window.title = "Do You Know The Word?"
        window.collectionBehavior = [.fullScreenAuxiliary, .fullScreenNone]
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }
}

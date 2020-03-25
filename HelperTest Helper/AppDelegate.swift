//
//  AppDelegate.swift
//  HelperTest Helper
//
//  Created by David Albert on 3/24/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!

    let listener = NSXPCListener(machServiceName: Bundle.main.bundleIdentifier!)
    let delegate = ServiceDelegate()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        listener.delegate = delegate
        listener.resume()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


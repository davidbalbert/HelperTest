//
//  AppDelegate.swift
//  HelperTest
//
//  Created by David Albert on 3/24/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!
    @IBOutlet var textField: NSTextField!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard SMLoginItemSetEnabled("is.dave.HelperTest-Helper" as CFString, true) else {
            print("couldn't enable login item")
            return
        }

        let connection = NSXPCConnection(machServiceName: "is.dave.HelperTest-Helper", options: [])
        connection.remoteObjectInterface = NSXPCInterface(with: HelperXPCProtocol.self)
        connection.resume()

        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error in Helper: \(error.localizedDescription)", error)
        } as? HelperXPCProtocol

        service?.sayHello { reply in
            DispatchQueue.main.async {
                self.textField.stringValue = reply
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}


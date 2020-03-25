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
class AppDelegate: NSObject, NSApplicationDelegate, MainXPCProtocol {
    @IBOutlet var window: NSWindow!
    @IBOutlet var textView: NSTextView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        guard SMLoginItemSetEnabled("is.dave.HelperTest-Helper" as CFString, true) else {
            print("couldn't enable login item")
            return
        }

        let connection = NSXPCConnection(machServiceName: "is.dave.HelperTest-Helper", options: [])
        connection.remoteObjectInterface = NSXPCInterface(with: HelperXPCProtocol.self)

        connection.exportedInterface = NSXPCInterface(with: MainXPCProtocol.self)
        connection.exportedObject = self

        connection.resume()

        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received error in Main: \(error.localizedDescription)", error)
        } as? HelperXPCProtocol

        service?.sayHello { reply in
            DispatchQueue.main.async {
                self.textView.string = reply
            }
        }
    }

    func setString(_ s: String) {
        textView.string = s
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}


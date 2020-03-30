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
class AppDelegate: NSObject, NSApplicationDelegate, AppProtocol, NSXPCListenerDelegate {
    @IBOutlet var window: NSWindow!
    @IBOutlet var textView: NSTextView!

    var listener: NSXPCListener!

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard SMLoginItemSetEnabled("9K689XE65M.is.dave.HelperTest-Helper" as CFString, true) else {
            NSLog("xxxx app: couldn't enable login item")
            return
        }

        setupXPC()
    }

    func applicationWillTerminate(_ notification: Notification) {
        SMLoginItemSetEnabled("9K689XE65M.is.dave.HelperTest-Helper" as CFString, false)
    }

    func setupXPC() {
        let connection = NSXPCConnection(machServiceName: "9K689XE65M.is.dave.HelperTest-Helper", options: [])
        connection.remoteObjectInterface = NSXPCInterface(with: RendezvousPoint.self)


        connection.resume()

        let service = connection.remoteObjectProxyWithErrorHandler { error in
            NSLog("xxxx Received error in App: \(error.localizedDescription) \(error)")
        } as! RendezvousPoint

        listener = NSXPCListener.anonymous()
        listener.delegate = self
        listener.resume()

        NSLog("xxxx app: send register app")
        service.registerApp(endpoint: listener.endpoint)

        connection.interruptionHandler = {
            NSLog("xxxx app: interrupt")
            service.registerApp(endpoint: self.listener.endpoint)
        }
    }

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        NSLog("xxxx app: new connection")

        newConnection.exportedInterface = NSXPCInterface(with: AppProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()

        return true
    }

    func speakText(_ s: String) {
        DispatchQueue.main.async {
            self.textView.string = s
        }
    }
}


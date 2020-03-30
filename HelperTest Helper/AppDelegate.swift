//
//  AppDelegate.swift
//  HelperTest Helper
//
//  Created by David Albert on 3/24/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSXPCListenerDelegate, RendezvousPoint {
    let listener = NSXPCListener(machServiceName: Bundle.main.bundleIdentifier!)
    var endpoint: NSXPCListenerEndpoint?
    var serviceProviderCallback: ((NSXPCListenerEndpoint) -> Void)?

    func applicationDidFinishLaunching(_ notification: Notification) {
        listener.delegate = self
        listener.resume()
    }

    func applicationWillTerminate(_ notification: Notification) {
        NSLog("xxxx helper: terminate")
    }

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: RendezvousPoint.self)
        newConnection.exportedObject = self
        newConnection.resume()

        return true
    }

    func registerApp(endpoint: NSXPCListenerEndpoint) {
        NSLog("xxxx helper: register app")

        self.endpoint = endpoint

        if let reply = serviceProviderCallback {
            reply(endpoint)
        }
    }

    func registerServiceProvider(withReply reply: @escaping (NSXPCListenerEndpoint) -> Void) {
        NSLog("xxxx helper: register service provider")

        if let endpoint = endpoint {
            reply(endpoint)
        } else {
            serviceProviderCallback = reply
        }
    }
}


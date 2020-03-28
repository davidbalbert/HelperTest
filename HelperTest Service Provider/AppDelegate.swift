//
//  AppDelegate.swift
//  HelperTest Service Provider
//
//  Created by David Albert on 3/25/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var window: NSWindow!

    var directConnection: NSXPCConnection?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let helperConnection = NSXPCConnection(machServiceName: "is.dave.HelperTest-Helper", options: [])
        helperConnection.remoteObjectInterface = NSXPCInterface(with: RendezvousPoint.self)
        helperConnection.resume()

        let service = helperConnection.remoteObjectProxyWithErrorHandler { error in
            NSLog("xxxx Received error in ServiceProvider: \(error.localizedDescription) \(error)")
        } as? RendezvousPoint

        NSLog("xxxx service provider: send register service provider")
        service?.registerServiceProvider { endpoint in
            DispatchQueue.main.async {
                NSLog("xxxx service provider: registered")
                let directConnection = NSXPCConnection(listenerEndpoint: endpoint)
                directConnection.remoteObjectInterface = NSXPCInterface(with: AppProtocol.self)
                directConnection.resume()

                self.directConnection = directConnection

                NSApp.servicesProvider = self
            }
        }
    }

    @objc func sendText(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>) {

        NSLog("xxxx service provider: service called")

        guard let items = pboard.pasteboardItems else { return }
        guard let type = items[0].availableType(from: [NSPasteboard.PasteboardType(rawValue: "public.plain-text")]) else { return }

        guard let s = items[0].string(forType: type) else { return }

        NSLog("xxxx service provider: %@\n", s as NSString)

        guard let directConnection = directConnection else {
            NSLog("xxxx service provider: no direct connection")
            return
        }

        let service = directConnection.remoteObjectProxyWithErrorHandler { error in
            NSLog("xxxx Received error in ServiceProvider (direct connection): \(error.localizedDescription) \(error)")
        } as? AppProtocol

        NSLog("xxxx service provider: send text to app \(service)")
        service?.speakText(s)
    }
}


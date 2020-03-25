//
//  AppDelegate.swift
//  HelperTest Helper
//
//  Created by David Albert on 3/24/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSXPCListenerDelegate, HelperXPCProtocol {

    @IBOutlet var window: NSWindow!

    let listener = NSXPCListener(machServiceName: Bundle.main.bundleIdentifier!)
    var connection: NSXPCConnection?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.servicesProvider = self

        listener.delegate = self
        listener.resume()
    }

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: HelperXPCProtocol.self)
        newConnection.exportedObject = self
        newConnection.resume()

        connection = newConnection

        return true
    }

    func sayHello(withReply reply: @escaping (String) -> Void) {
        reply("Hello, XPC world!")
    }

    @objc func sendText(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>) {

        NSLog("service called")

        guard let items = pboard.pasteboardItems else { return }
        guard let type = items[0].availableType(from: [NSPasteboard.PasteboardType(rawValue: "public.plain-text")]) else { return }

        guard let s = items[0].string(forType: type) else { return }

        NSLog("%@\n", s as NSString)

        let service = connection!.remoteObjectProxyWithErrorHandler { error in
            NSLog("Received error in Helper: \(error.localizedDescription) \(error)")
        } as? MainXPCProtocol

        service!.setString(s)
    }
}


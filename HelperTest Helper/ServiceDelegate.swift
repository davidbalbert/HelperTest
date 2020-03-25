//
//  ServiceDelegate.swift
//  HelperTest Helper
//
//  Created by David Albert on 3/25/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa

class ServiceDelegate: NSObject, NSXPCListenerDelegate {
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: HelperXPCProtocol.self)
        newConnection.exportedObject = HelperXPC()
        newConnection.resume()

        return true
    }
}

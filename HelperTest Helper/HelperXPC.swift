//
//  HelperXPC.swift
//  HelperTest Helper
//
//  Created by David Albert on 3/25/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Cocoa

class HelperXPC: NSObject, HelperXPCProtocol {
    func sayHello(withReply reply: @escaping (String) -> Void) {
        reply("Hello, XPC world!")
    }
}

//
//  HelperXPCProtocol.swift
//  HelperTest
//
//  Created by David Albert on 3/25/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Foundation

@objc protocol HelperXPCProtocol {
    func sayHello(withReply reply: @escaping (String) -> Void)
}

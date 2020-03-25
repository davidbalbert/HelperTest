//
//  MainXPCProtocol.swift
//  HelperTest
//
//  Created by David Albert on 3/25/20.
//  Copyright © 2020 David Albert. All rights reserved.
//

import Foundation

@objc protocol MainXPCProtocol {
    func setString(_ s: String)
}

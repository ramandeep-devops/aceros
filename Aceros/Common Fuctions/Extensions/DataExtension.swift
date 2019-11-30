
//
//  DataExtension.swift
//  SideDrawer
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Codebrew Labs. All rights reserved.
//

import Foundation

extension Data {
    
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    
}


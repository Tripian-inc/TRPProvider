//
//  String+Extensions.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 14.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
enum RegEx: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" // Email
    case password = "^.{6,40}$" // Password length 1-40
}

extension String {
    
    var isValidEmail: Bool {
        let validatedStr = NSPredicate(format:"SELF MATCHES %@", RegEx.email.rawValue)
        let result = validatedStr.evaluate(with: self)
        return result
    }
    
    
    
}

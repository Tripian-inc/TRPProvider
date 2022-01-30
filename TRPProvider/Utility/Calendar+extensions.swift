//
//  Calendar+extensions.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 30.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation

extension Calendar {
    static var currentWithUTC: Calendar {
        get {
            var cal = Calendar.current
            if let timeZone = TimeZone(identifier: "UTC") {
                cal.timeZone = timeZone
            }
            return cal
        }
    }
}

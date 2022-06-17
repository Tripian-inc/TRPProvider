//
//  Date+Extensions.swift
//  TRPProvider
//
//  Created by Cem Çaygöz on 17.06.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(format: String? = "yyyy-MM-dd'T'HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let f = format {
            formatter.dateFormat = f
        }
        return formatter.string(from: self)
    }
}

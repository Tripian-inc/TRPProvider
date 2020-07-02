//
//  YelpOpenings.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
struct YelpOpenings: Codable {
    let reservationTimes: [YelpReservationTime]

    enum CodingKeys: String, CodingKey {
        case reservationTimes = "reservation_times"
    }
}

// MARK: - ReservationTime
struct YelpReservationTime: Codable {
    let date: String
    let times: [YelpTime]
}

// MARK: - Time
struct YelpTime: Codable {
    let creditCardRequired: Bool
    let time: String

    enum CodingKeys: String, CodingKey {
        case creditCardRequired = "credit_card_required"
        case time
    }
}

/**
{
    "reservation_times": [
        {
            "date": "2020-09-09",
            "times": [
                
                {
                    "credit_card_required": false,
                    "time": "23:30"
                },
                {
                    "credit_card_required": false,
                    "time": "23:45"
                }
            ]
        },
        {
            "date": "2020-09-08",
            "times": [
                {
                    "credit_card_required": false,
                    "time": "00:00"
                },
                {
                    "credit_card_required": false,
                    "time": "00:15"
                }
            ]
        }
        
    ]
}
*/

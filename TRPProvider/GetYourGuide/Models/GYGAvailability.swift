//
//  GYGAvailability.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 1.10.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public struct GYGAvailability: Codable {
    public let startTime: String
    public let pricingID, vacancies: Int
    public let discount: Int?

    enum CodingKeys: String, CodingKey {
        case startTime = "start_time"
        case pricingID = "pricing_id"
        case vacancies, discount
    }
}

internal class GYGAvailabilities: Decodable {
    
    public var availabilities: [GYGAvailability]?
    
    private enum CodingKeys: String, CodingKey {
        case availabilities
    }
    
}




//
//  GYGOptionPricing.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.10.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

internal class GYGGYGPricingWithCategoryParser: Decodable {
    
    public var pricing: [GYGOptionPricing]?
    
    private enum CodingKeys: String, CodingKey {
        case pricing
    }
    
}


// MARK: - Pricing
public struct GYGOptionPricing: Codable {
    public let categories: [PricingCategory]
    public let pricingID, totalMinimumParticipants: Int

    enum CodingKeys: String, CodingKey {
        case categories
        case pricingID = "pricing_id"
        case totalMinimumParticipants = "total_minimum_participants"
    }
}

// MARK: - Category
public struct PricingCategory: Codable {
    public let maxAge: Int?
    public let addon: Bool
    public let scale: [PricingScale]
    public let id: Int
    public let standAlone: Bool
    public let name: String
    public let minAge: Int?

    enum CodingKeys: String, CodingKey {
        case maxAge = "max_age"
        case addon, scale, id
        case standAlone = "stand_alone"
        case name
        case minAge = "min_age"
    }
}

// MARK: - Scale
public struct PricingScale: Codable {
    public let type: String
    public let minParticipants, maxParticipants: Int?
    public let retailPrice, netPrice: Double?

    enum CodingKeys: String, CodingKey {
        case type
        case minParticipants = "min_participants"
        case maxParticipants = "max_participants"
        case retailPrice = "retail_price"
        case netPrice = "net_price"
    }
}

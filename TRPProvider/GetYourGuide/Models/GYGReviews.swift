//
//  GYGReviews.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 23.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public struct GYGReviews: Codable {
    public let outline: [GYGOutline]
    public let reviewItems: [GYGReview]

    enum CodingKeys: String, CodingKey {
        case outline
        case reviewItems = "review_items"
    }
}




internal class GYGToursParser: Decodable {
    
    public var reviews: GYGReviews?
    
    private enum CodingKeys: String, CodingKey {
        case reviews
    }
    
}


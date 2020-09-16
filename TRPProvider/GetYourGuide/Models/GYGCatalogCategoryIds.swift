//
//  GYGCatalogCategoryIds.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 14.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public enum GYGCatalogCategory: String, CaseIterable {
    
    case tour = "Tour"
    case advantureNature = "Advanture Nature"
    case cultureHistory = "Culture History"
    case cruiseSailingAndBoatTours = "Cruise Sailing And Boat Tours"
    case foodAndDrinks = "Food And Drinks"
    case luxuryAndSpecialOccasions = "Luxury And Special Occasions"
    
    
    
    public func ids() -> [Int] {
        switch  self {
        case .tour:
            return [1, 2, 221]
        case .advantureNature:
            return [35, 41, 238, 36, 40, 255, 37, 39, 309, 43, 195, 49, 38, 308, 42, 310, 312, 307, 136]
        case .cultureHistory:
            return [27, 33, 29, 34, 28, 180, 266, 229, 32, 31, 24, 527, 236, 272, 220, 160, 231, 477, 254, 301, 237, 242, 467, 294, 522]
        case .cruiseSailingAndBoatTours:
            return [48, 51, 258, 50, 53, 270, 264, 164, 363, 52];
        case .foodAndDrinks:
            return [103, 105, 104, 532, 248, 167, 107, 263, 204, 246, 261, 297, 305, 106, 108, 279, 351, 441, 353, 292, 289]
        case .luxuryAndSpecialOccasions:
            return [287]
        }
    }
}

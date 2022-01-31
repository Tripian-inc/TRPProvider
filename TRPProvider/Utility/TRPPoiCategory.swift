//
//  TRPPoiCategory.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 30.01.2022.
//  Copyright © 2022 Tripian Inc. All rights reserved.
//

import Foundation
public enum TRPPoiCategory: String, CaseIterable {
    
    case attractions = "Attractions"
    case restaurants = "Restaurants"
    case nightLife = "Nightlife"
    case coolFinds = "Cool Finds"
    case cafes = "Cafes"
    case religiousPlaces = "Religious Places"
    case theater = "Theater"
    case cinema = "Cinema"
    case stadium = "Stadium"
    case civicCenter = "Civic Center"
    case museum = "Museum"
    case bar = "Bar"
    case artGallery = "Art Gallery"
    case bakery = "Bakery"
    case shoppingCenter = "Shopping Center"
    case brewery = "Brewery"
    case dessert = "Dessert"
    
    func toString() -> String {
        return self.rawValue.toLocalized()
    }
    
    func getSingler() -> String {
        switch self {
        case .attractions:
            return "Attraction"
        case .restaurants:
            return "Restaurant"
        case .coolFinds:
            return "Cool Find"
        case .cafes:
            return "Cafe"
        case .religiousPlaces:
            return "Religious Place"
        default:
            return self.rawValue
        }
    }
    
    static func idToType(_ id: Int) -> Self? {
        for type in TRPPoiCategory.allCases {
            if type.getId() == id {
                return type
            }
        }
        return nil
    }
    
    func getId() -> Int {
        switch self {
        case .attractions:
            return 1
        case .restaurants:
            return 3
        case .nightLife:
            return 4
        case .coolFinds:
            return 8
        case .cafes:
            return 24
        case .religiousPlaces:
            return 25
        case .theater:
            return 26
        case .cinema:
            return 27
        case .stadium:
            return 28
        case .civicCenter:
            return 29
        case .museum:
            return 30
        case .bar:
            return 31
        case .artGallery:
            return 32
        case .bakery:
            return 33
        case .shoppingCenter:
            return 34
        case .brewery:
            return 35
        case .dessert:
            return 36
        }
    }
    
}

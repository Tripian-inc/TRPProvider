//
//  GYGTour.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 11.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
struct GYGTour: Codable {
    
    let tourID: Int
    let tourCode: String
    let condLanguage: [String]
    let title, abstract: String
    let bestseller, certified: Bool
    let overallRating: Double
    let numberOfRatings: Int
    let pictures: [GYGPicture]
    let coordinates: GYGCoordinates
    let price: GYGPrice
    let categories: [GYGCategory]
    let locations: [GYGLocation]
    let url: String
    let durations: [GYGDuration]

    enum CodingKeys: String, CodingKey {
        case tourID = "tour_id"
        case tourCode = "tour_code"
        case condLanguage = "cond_language"
        case title, abstract, bestseller, certified
        case overallRating = "overall_rating"
        case numberOfRatings = "number_of_ratings"
        case pictures, coordinates, price, categories, locations, url, durations
    }
}

struct GYGCategory: Codable {
    let categoryID: Int
    let name: String?
    let parentID: Int?

    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case name
        case parentID = "parent_id"
    }
}

// MARK: - Coordinates
struct GYGCoordinates: Codable {
    let lat, long: Double
}

// MARK: - Duration
struct GYGDuration: Codable {
    let duration: Double
    let unit: GYGUnit
}

enum GYGUnit: String, Codable {
    case day = "day"
    case hour = "hour"
}

// MARK: - Location
struct GYGLocation: Codable {
    let locationID: Int
    let type: String
    let name, englishName, city: String
    let country: String
    let coordinates: GYGCoordinates
    let viewport: GYGViewport

    enum CodingKeys: String, CodingKey {
        case locationID = "location_id"
        case type, name
        case englishName = "english_name"
        case city, country, coordinates, viewport
    }
}


// MARK: - Viewport
struct GYGViewport: Codable {
    let swLat, swLong, neLat, neLong: Double

    enum CodingKeys: String, CodingKey {
        case swLat = "sw_lat"
        case swLong = "sw_long"
        case neLat = "ne_lat"
        case neLong = "ne_long"
    }
}

// MARK: - Picture
struct GYGPicture: Codable {
    let id: Int
    let url, sslURL: String
    let verified: Bool

    enum CodingKeys: String, CodingKey {
        case id, url
        case sslURL = "ssl_url"
        case verified
    }
}

// MARK: - Price
struct GYGPrice: Codable {
    let values: GYGValues
    let priceDescription: String

    enum CodingKeys: String, CodingKey {
        case values
        case priceDescription = "description"
    }
}


// MARK: - Values
struct GYGValues: Codable {
    let amount: Double
    let special: GYGSpecial?
}

// MARK: - Special
struct GYGSpecial: Codable {
    let originalPrice: Double
    let savings: Int

    enum CodingKeys: String, CodingKey {
        case originalPrice = "original_price"
        case savings
    }
}

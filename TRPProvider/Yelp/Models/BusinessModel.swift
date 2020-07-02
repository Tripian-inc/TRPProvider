//
//  BusinessModel.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
struct YelpBusiness: Codable {
    let id: String
    let alias: String
    let name: String
    let imageURL: String
    let isClaimed, isClosed: Bool
    let url: String
    let phone, displayPhone: String
    let reviewCount: Int
    let categories: [YelpCategory]
    let rating: Int
    let location: YelpLocation
    let coordinates: YelpCoordinates
    let photos: [String]
    let price: String
    let hours: [YelpHour]
    let transactions: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClaimed = "is_claimed"
        case isClosed = "is_closed"
        case url, phone
        case displayPhone = "display_phone"
        case reviewCount = "review_count"
        case categories, rating, location, coordinates, photos, price, hours, transactions
    }
}

// MARK: - Category
struct YelpCategory: Codable {
    let alias, title: String
}

// MARK: - Coordinates
struct YelpCoordinates: Codable {
    let latitude, longitude: Double
}

// MARK: - Hour
struct YelpHour: Codable {
    let hourOpen: [YelpOpen]
    let hoursType: String
    let isOpenNow: Bool

    enum CodingKeys: String, CodingKey {
        case hourOpen = "open"
        case hoursType = "hours_type"
        case isOpenNow = "is_open_now"
    }
}

// MARK: - Open
struct YelpOpen: Codable {
    let isOvernight: Bool
    let start, end: String
    let day: Int

    enum CodingKeys: String, CodingKey {
        case isOvernight = "is_overnight"
        case start, end, day
    }
}

// MARK: - Location
struct YelpLocation: Codable {
    let address1, address2, address3, city: String
    let zipCode, country, state: String
    let displayAddress: [String]
    let crossStreets: String

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
        case crossStreets = "cross_streets"
    }
}

/**
{
    "id": "gR9DTbKCvezQlqvD7_FzPw",
    "alias": "north-india-restaurant-san-francisco",
    "name": "North India Restaurant",
    "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/howYvOKNPXU9A5KUahEXLA/o.jpg",
    "is_claimed": true,
    "is_closed": false,
    "url": "https://www.yelp.com/biz/north-india-restaurant-san-francisco?adjust_creative=liqimTxDxUYNXavoxs15Pg&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=liqimTxDxUYNXavoxs15Pg",
    "phone": "+14153481234",
    "display_phone": "(415) 348-1234",
    "review_count": 1740,
    "categories": [
        {
            "alias": "indpak",
            "title": "Indian"
        }
    ],
    "rating": 4.0,
    "location": {
        "address1": "123 Second St",
        "address2": "",
        "address3": "",
        "city": "San Francisco",
        "zip_code": "94105",
        "country": "US",
        "state": "CA",
        "display_address": [
            "123 Second St",
            "San Francisco, CA 94105"
        ],
        "cross_streets": ""
    },
    "coordinates": {
        "latitude": 37.787789124691,
        "longitude": -122.399305736113
    },
    "photos": [
        "https://s3-media1.fl.yelpcdn.com/bphoto/howYvOKNPXU9A5KUahEXLA/o.jpg",
        "https://s3-media2.fl.yelpcdn.com/bphoto/I-CX8nioj3_ybAAYmhZcYg/o.jpg",
        "https://s3-media3.fl.yelpcdn.com/bphoto/uaSNfzJUiFDzMeSCwTcs-A/o.jpg"
    ],
    "price": "$$",
    "hours": [
        {
            "open": [
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2300",
                    "day": 0
                },
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2300",
                    "day": 1
                },
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2300",
                    "day": 2
                },
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2300",
                    "day": 3
                },
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2330",
                    "day": 4
                },
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2330",
                    "day": 5
                },
                {
                    "is_overnight": false,
                    "start": "1000",
                    "end": "2300",
                    "day": 6
                }
            ],
            "hours_type": "REGULAR",
            "is_open_now": false
        }
    ],
    "transactions": [
        "delivery",
        "restaurant_reservation",
        "pickup"
    ]
}
*/

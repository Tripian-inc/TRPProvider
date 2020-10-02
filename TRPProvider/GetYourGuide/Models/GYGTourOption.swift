//
//  GYGTourOption.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.10.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
internal class GYGToursOptionParser: Decodable {
    
    public var options: [GYGTourOption]?
    
    private enum CodingKeys: String, CodingKey {
        case options = "tour_options"
    }
    
}



struct GYGTourOption: Codable {
    let optionID, tourID: Int
    let title, meetingPoint, dropOff: String
    let duration: Int
    let durationUnit: String
    let condLanguage: GYGCondLanguage
    let bookingParameter: [GYGBookingParameter]
    let services: [String: Bool]
    let coordinateType: String
    let coordinates: GYGCoordinates
    let price: GYGPrice
    let freeSale: Bool

    enum CodingKeys: String, CodingKey {
        case optionID = "option_id"
        case tourID = "tour_id"
        case title
        case meetingPoint = "meeting_point"
        case dropOff = "drop_off"
        case duration
        case durationUnit = "duration_unit"
        case condLanguage = "cond_language"
        case bookingParameter = "booking_parameter"
        case services
        case coordinateType = "coordinate_type"
        case coordinates, price
        case freeSale = "free_sale"
    }
}

// MARK: - BookingParameter
struct GYGBookingParameter: Codable {
    let name: String
    let mandatory: Bool
    let description: String?

    enum CodingKeys: String, CodingKey {
        case name, mandatory
        case description
    }
}

struct GYGCondLanguage: Codable {
    let languageAudio: [String]
    let languageBooklet, languageLive: [String]

    enum CodingKeys: String, CodingKey {
        case languageAudio = "language_audio"
        case languageBooklet = "language_booklet"
        case languageLive = "language_live"
    }
}

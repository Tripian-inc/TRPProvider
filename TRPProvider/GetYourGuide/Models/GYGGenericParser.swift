//
//  GYGGenericParser.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 11.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
internal class GYGGenericParser<T: Decodable>: Decodable {
    
    public var data: T?
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try values.decodeIfPresent(T.self, forKey: .data)
        
    }
    
}


internal class GYGGenericData: Decodable {
    
    public var data: GYGTours?
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try values.decodeIfPresent(GYGTours.self, forKey: .data)
    }
    
}


internal class GYGTours: Decodable {
    
    public var tours: [GYGTour]?
    
    private enum CodingKeys: String, CodingKey {
        case tours
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.tours = try values.decodeIfPresent([GYGTour].self, forKey: .tours)
    }
    
}

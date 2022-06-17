//
//  NetworkError.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 13.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameters encoding failed."
    case missingUrl = "URL is nil."
    
}

public enum GYGNetworkError: Error {
    case customError(code:String, message:String)
    
    init(code: String, message: String) {
        switch code {
        default: self = .customError(code: code, message: message)
        }
    }
}
extension GYGNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError(_, let message):
            return message
        }
    }
    
    public var localizedDescription: String? {
        switch self {
        case .customError(_, let message):
            return message
        }
    }
}


public enum YelpNetworkError: Error {
    case yelpErrorMessage(code: String, message: String)
    case reservationCanceled
    
    init(code: String, message: String) {
        switch code {
        case "RESERVATION_CANCELED": self = .reservationCanceled
        default: self = .yelpErrorMessage(code: code, message: message)
        }
    }
    
}

extension YelpNetworkError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.yelpErrorMessage,.yelpErrorMessage): return true
        case (.reservationCanceled,.reservationCanceled): return true
        default:
            return false
        }
    }
}


extension YelpNetworkError : LocalizedError{
    
    public var localizedDescription: String? {
        switch self {
        case .yelpErrorMessage(_, let message):
            return message
        case .reservationCanceled:
            return "This reservation has been canceled."
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .yelpErrorMessage(_, let message):
            return message
        case .reservationCanceled:
            return "This reservation has been canceled."
        }
    }
    
}

public enum TravelTimeNetworkError: Error {
    case customError(code:String, message:String)
    
    init(code: String, message: String) {
        switch code {
        default: self = .customError(code: code, message: message)
        }
    }
    
}
extension TravelTimeNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .customError(_, let message):
            return message
        }
    }
    
    public var localizedDescription: String? {
        switch self {
        case .customError(_, let message):
            return message
        }
    }
}

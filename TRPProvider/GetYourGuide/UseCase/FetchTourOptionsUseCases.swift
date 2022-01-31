//
//  FetchTourOptionsUseCases.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2020-12-26.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public protocol FetchTourOptionsUseCase {
    
    func tourAvailabilities(id: Int,
                                fromDate from: String,
                                toDate to:String,
                                completion: @escaping (Result<[GYGAvailability], Error>) -> Void)
    func tourOptions(tourId id: Int,
                    fromDate from: String? ,
                    toDate to:String? ,
                    completion: @escaping (Result<[GYGTourOption], Error>) -> Void)
    
    func optionPricings(optionId id: Int,
                        completion: @escaping (Result<[GYGOptionPricing], Error>) -> Void)
    
}

public protocol TourOptionDataHolder {
    var availabilities: [GYGAvailability] { get set }
    var tourOptions: [GYGTourOption] { get set}
    var optionsPricing: [GYGOptionPricing] { get set}
}

public class TRPTourOptionsUseCases: TourOptionDataHolder {
    
    public let language: String
    public let currency: String
    
    public var availabilities: [GYGAvailability] = []
    public var tourOptions: [GYGTourOption] = []
    public var optionsPricing: [GYGOptionPricing] = []
  
    private var gygApi: GetYourGuideApi
    
    public init(language: String = "en",
                currency: String = "usd",
                gygApi: GetYourGuideApi) {
        self.language = language
        self.currency = currency
        self.gygApi = gygApi
    }
}

extension TRPTourOptionsUseCases: FetchTourOptionsUseCase {
    public func tourAvailabilities(id: Int, fromDate from: String, toDate to: String, completion: @escaping (Result<[GYGAvailability], Error>) -> Void) {
        gygApi.tourAvailabilities(id: id, language: language, currency: currency, fromDate: from, toDate: to) {[weak self] result in
            switch result{
            case .success(let availabilities):
                self?.availabilities = availabilities
                completion(.success(availabilities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func tourOptions(tourId id: Int, fromDate from: String?, toDate to: String?, completion: @escaping (Result<[GYGTourOption], Error>) -> Void) {
        
        gygApi.tourOptions(tourId: id, language: language, currency: currency, fromDate: from, toDate: to) { [weak self] result in
            switch result{
            case .success(let options):
                self?.tourOptions = options
                completion(.success(options))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func optionPricings(optionId id: Int, completion: @escaping (Result<[GYGOptionPricing], Error>) -> Void) {
        gygApi.optionPricings(optionId: id, language: language, currency: currency) { [weak self] result in
            switch result{
            case .success(let pricing):
                self?.optionsPricing = pricing
                completion(.success(pricing))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

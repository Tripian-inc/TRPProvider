//
//  GetYourGuideApi.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 11.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public class GetYourGuideApi {
    //rC5mIHMNF5C1Jtpb2obSkA
    var network: Networking?
    //TODO: TAŞINACAK
    internal let apiKey = "Yb8XauGtHKbBUEj4PGWRfrvzvmwKijdghHwWkjBVYTKmTFeR"
    
    private var networkController: NetworkController?
    
    
    public init(network: Networking = Networking()) {
        self.network = network
        networkController = createNetworkController(network: network)
    }
    
    private func createNetworkController(network: Networking) -> NetworkController {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.getyourguide.com"
        return NetworkController(network: network)
            .urlComponent(urlComponent)
            .addValue("X-ACCESS-TOKEN", value: apiKey)
    }
    
}


//MARK: - Tours
extension GetYourGuideApi {
    
    //preformatted: String = "teaser",
    public func tours(cityName: String,
                      categoryIds: [Int]? = nil,
                      preformatted: String = "full",
                      language: String = "en",
                      currency: String = "usd",
                      limit: Int = 100,
                      completion: @escaping (Result<[GYGTour], Error>) -> Void) {
        
        
        let path = "/1/tours"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        params["q"] = "\(cityName)"
        params["preformatted"] = "\(preformatted)"
        params["limit"] = "\(limit)"
        if let category = categoryIds, category.count > 0 {
            let converted = category.map{"\($0)"}
            params["categories"] = converted.joined(separator: ",")
        }
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGTours>.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model.data?.tours ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

//MARK: - Tour
extension GetYourGuideApi {
    
    public func tour(id: Int,
                     preformatted: String = "full",
                     language: String = "en",
                     currency: String = "usd",
                     completion: @escaping (Result<GYGTour, Error>) -> Void) {
        let path = "/1/tours/\(id)"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        params["preformatted"] = "\(preformatted)"
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGTours>.self) { (result) in
            switch result {
            case .success(let model):
                if let tour = model.data?.tours?.first {
                    completion(.success(tour))
                }else {
                    print("Error tour is not found")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - id: TourId
    ///   - language: <#language description#>
    ///   - currency: <#currency description#>
    ///   - from: "Y-m-dTH:i:s"
    ///   - to: "Y-m-dTH:i:s"
    ///   - completion: <#completion description#>
    public func tourAvailabilities(id: Int,
                                   language: String = "en",
                                   currency: String = "usd",
                                   fromDate from: String,
                                   toDate to:String,
                                   completion: @escaping (Result<[GYGAvailability], Error>) -> Void) {
        let path = "/1/tours/\(id)/availabilities"
        var params = [URLQueryItem]()
        params.append(URLQueryItem(name: "cnt_language", value: "\(language)"))
        params.append(URLQueryItem(name: "currency", value: "\(currency)"))
        params.append(URLQueryItem(name: "date[]", value: from))
        params.append(URLQueryItem(name: "date[]", value: to))
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGAvailabilities>.self) { (result) in
            switch result {
            case .success(let model):
                
                print("MODEL \(model)")
                completion(.success(model.data?.availabilities ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func tourOptions(tourId id: Int,
                                   language: String = "en",
                                   currency: String = "usd",
                                   fromDate from: String? = nil,
                                   toDate to:String? = nil,
                                   completion: @escaping (Result<[GYGTourOption], Error>) -> Void) {
        let path = "/1/tours/\(id)/options"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        if let fromDate = from {
            params["date[]"] = fromDate
        }
        if let toDate = to {
            params["date[]"] = toDate
        }
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGToursOptionParser>.self) { (result) in
            switch result {
            case .success(let model):
                
                print("MODEL \(model)")
                completion(.success(model.data?.options ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func optionsAvailability(tourId id: Int,
                                   language: String = "en",
                                   currency: String = "usd",
                                   completion: @escaping (Result<[GYGTourOption], Error>) -> Void) {
        
    }
    
    public func optionsAvailability(optionId id: Int ) {
        // /options/[option_id]/availabilities
        
        
        
            
    }
    
}


//MARK: - Category
extension GetYourGuideApi {
    
    public func categories(language: String = "en",
                           currency: String = "usd",
                           limit: Int? = nil,
                           completion: @escaping (Result<[GYGCategory], Error>) -> Void) {
        
        let path = "/1/categories"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        
        if let limit = limit {
            params["limit"] = "\(limit)"
        }
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGCategories>.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model.data?.categories ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    public func category(id: Int,
                         language: String = "en",
                         currency: String = "usd",
                         limit: Int? = nil,
                         completion: @escaping (Result<[GYGCategory], Error>) -> Void) {
        
        let path = "/1/categories/\(id)"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        
        if let limit = limit {
            params["limit"] = "\(limit)"
        }
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGCategories>.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model.data?.categories ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


//MARK: - Reviews
extension GetYourGuideApi {
    
    public func reviews(tourId:Int,
                        language: String = "en",
                        currency: String = "usd",
                        sortfield: GYGSortField? = nil,
                        sortDirection: GYGSortDirection? = nil,
                        limit: Int? = nil,
                        completion: @escaping (Result<GYGReviews, Error>) -> Void) {
        
        let path = "/1/reviews/tour/\(tourId)"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        
        if let sortField = sortfield {
            params["sortfield"] = sortField.rawValue
        }
        
        if let sortDirection = sortDirection {
            params["sortdirection"] = sortDirection.rawValue
        }
        
        if let limit = limit {
            params["limit"] = "\(limit)"
        }
        
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGToursParser>.self) { (result) in
            switch result {
            case .success(let model):
                
                if model.data?.reviews != nil {
                    completion(.success(model.data!.reviews!))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}


extension GetYourGuideApi {
    
    public func optionPricings(optionId id: Int,
                                   language: String = "en",
                                   currency: String = "usd",
                                   completion: @escaping (Result<[GYGOptionPricing], Error>) -> Void) {
        let path = "/1/options/\(id)/pricings"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericDataParser<GYGGYGPricingWithCategoryParser>.self) { (result) in
            switch result {
            case .success(let model):
                
                print("MODEL \(model)")
                completion(.success(model.data?.pricing ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension GetYourGuideApi {
    public func booking(optionId: Int,
                        dateTime: String,
                        price: String,
                        categories: [GYGBookingCategoryPropeties],
                        bookingParameters: [GYGBookingParameterProperties],
                        language: String = "en",
                        currency: String = "usd",
                        completion: @escaping (Result<GYGBookings, Error>) -> Void) {
        
        let path = "/1/bookings"
       
        var bookableParams = [String: String]()
        bookableParams["option_id"] = "\(optionId)"
        bookableParams["datetime"] = "\(dateTime)"
        bookableParams["price"] = "\(price)"
        bookableParams["categories"] = "\(categories.compactMap({$0.getParams()}))"
        bookableParams["booking_parameters"] = "\(bookingParameters.compactMap({$0.getParams()}))"
        
        var booking = [String: Any]()
        booking["booking"] = bookableParams
        
        networkController?.urlComponentPath(path).bodyParameters(booking).responseDecodable(type: GYGGenericDataParser<GYGBookingsParser>.self) { (result) in
            switch result {
            case .success(let model):
                
                print("MODEL \(model)")
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    
}

public protocol CustomDecodable {
    func getParams() -> [String: Any]
}

public struct GYGBookingCategoryPropeties: CustomDecodable {

    public var categoryId: Int
    public var numberOfParticipants: Int
    
    public init(categoryId: Int, numberOfParticipants: Int) {
        self.categoryId = categoryId
        self.numberOfParticipants = numberOfParticipants
    }
    
    public func getParams() -> [String : Any] {
        return ["category_id": "\(categoryId)", "number_of_participants": "\(numberOfParticipants)"]
    }
}


public struct GYGBookingParameterProperties: CustomDecodable {
    public var name: String
    public var value1: String
    public var value2: String?
    
    public init(name: String, value1: String, value2: String? = nil) {
        self.name = name
        self.value1 = value1
        self.value2 = value2
    }
    
    public func getParams() -> [String : Any] {
        var params = [String: String]()
        params["name"] = name
        params["value1"] = value1
        if let wrappedValue2 = value2 {
            params["value2"] = wrappedValue2
        }
        return params
    }
    
}

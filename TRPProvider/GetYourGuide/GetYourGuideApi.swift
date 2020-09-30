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
                      categoryIds: [Int]? = [],
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
        if let category = categoryIds {
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


//MARK: - Category
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

public enum GYGSortField: String {
    case popularity = "popularity"
    case price = "price"
    case rating = "rating"
    case duration = "duration"
}

public enum GYGSortDirection: String {
    case asc = "ASC"
    case desc = "DESC"
}

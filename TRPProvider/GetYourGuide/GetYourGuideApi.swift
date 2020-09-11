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


//MARK: - Business
extension GetYourGuideApi {
    
    
    public func tours(cityName: String,
                      cagetoryIds: [Int]? = [],
                      preformatted: String = "teaser",
                      language: String = "en",
                      currency: String = "usd",
                      limit: Int = 100,
                      completion: @escaping (Result<[GYGTour], Error>) -> Void) {
        
        //let path = "/1/tours?cnt_language=\(language)&currency=\(currency)&q=\(cityName)&preformatted=\(preformatted)&limit=\(limit)&categoryIds=\(cagetoryIds ?? [])"
        let path = "/1/tours"
        var params = [String: String]()
        params["cnt_language"] = "\(language)"
        params["currency"] = "\(currency)"
        params["q"] = "\(cityName)"
        params["preformatted"] = "\(preformatted)"
        params["limit"] = "\(limit)"
        //params["categoryIds"] = "\(cagetoryIds ?? "")"
        
        networkController?.urlComponentPath(path).parameters(params).responseDecodable(type: GYGGenericData.self) { (result) in
            switch result {
            case .success(let model):
                
                completion(.success(model.data?.tours ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}


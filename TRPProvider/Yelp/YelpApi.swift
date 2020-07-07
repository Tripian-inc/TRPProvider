//
//  YelpApi.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public class YelpApi {
    //rC5mIHMNF5C1Jtpb2obSkA
    var network: Networking?
    //TODO: TAŞINACAK
    internal let sandboxToken =
    "lKSyNooZ4m6EnK7530z9Enx2GAuym6UJxCwLVv82pjhB67LU_l89iQtfj-5pMasL7kt4AnjF_oW_gHAXiz84IQXcMLJVNFhc2aMRyd9YUAb3zv0K63voptIgbItlXXYx"
    
    //TODO: TAŞINACAK
    internal let productToken =
    "SyqU9E_sGpBMUoViM6DBQkpLpRu5sCEvlqxs0-xAuTREuDoiIjf1TsPC-0PoWeK6O2_TSaDOdCoLMeoj5khI16DDMLqhvHSsFeTi9UHWwtTsu5kZBNOiHkBGxnVmXXYx"
    private var networkController: NetworkController?
    
    internal var token = ""
    
    init(network: Networking = Networking(), isProduct: Bool = true) {
        self.network = network
        token = isProduct ? productToken : sandboxToken
        networkController = createNetworkController(network: network)
    }
    
    private func createNetworkController(network: Networking) -> NetworkController {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.yelp.com"
        return NetworkController(network: network)
                                .urlComponent(urlComponent)
                                .addValue("Authorization", value: "Bearer \(token)")
    }
    
}

//MARK: - Business
extension YelpApi {
    // businesses/${businessId}
    public func business(id: String, completion: @escaping (Result<YelpBusiness, Error>) -> Void) {
        let path = "/v3/businesses/\(id)"
        networkController?.urlComponentPath(path).responseDecodable(type: YelpBusiness.self) { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}




//MARK: - Openings
extension YelpApi {
    // /bookings/${businessId}/openings
    // https://api.yelp.com/v3/bookings/rC5mIHMNF5C1Jtpb2obSkA/openings?covers=1&date=2020-09-09&time=06:30
    
    public func openings(id: String, covers: Int = 1, date:String, time: String) {
        let path = "/v3/businesses/\(id)/openings"
        let params = ["covers": "\(covers)", "date":date, "time": time]
        networkController?
            .urlComponentPath(path)
            .parameters(params)
            .responseDecodable(type: YelpOpen.self) { (result) in
            switch result {
            case .success(_):
                print("SUCCESS")
            case .failure(let error):
                print("ERROR \(error)")
            }
        }
    }
    
}


//MARK: - Hold
extension YelpApi {
    // /bookings/${businessId}/holds
    public func hold(id: String, covers: Int = 1, date:String, time: String, uniqueId: String) {
        let path = "/v3/businesses/\(id)/holds?covers=\(covers)&date=\(date)&time=\(time)"
        let bodyParams = ["covers": "\(covers)", "date":date, "time": time, "unique_Id" : uniqueId]
        networkController?
            .urlComponentPath(path)
            .httpMethod(.post)
            .bodyParameters(bodyParams)
            .responseDecodable(type: YelpOpen.self) { (result) in
            switch result {
            case .success(_):
                print("SUCCESS")
            case .failure(let error):
                print("ERROR \(error)")
            }
        }
    }
}

//MARK: - Reservation
extension YelpApi {
    
}


//MARK: - ReservationStatus
extension YelpApi {
    
}

//MARK: - ReservationCancel
extension YelpApi {
    
}

//MARK: - HELPER
extension YelpApi {
    
}

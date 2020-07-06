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
    private let sandboxToken =
    "lKSyNooZ4m6EnK7530z9Enx2GAuym6UJxCwLVv82pjhB67LU_l89iQtfj-5pMasL7kt4AnjF_oW_gHAXiz84IQXcMLJVNFhc2aMRyd9YUAb3zv0K63voptIgbItlXXYx"
    
    //TODO: TAŞINACAK
    private let prodToken =
    "SyqU9E_sGpBMUoViM6DBQkpLpRu5sCEvlqxs0-xAuTREuDoiIjf1TsPC-0PoWeK6O2_TSaDOdCoLMeoj5khI16DDMLqhvHSsFeTi9UHWwtTsu5kZBNOiHkBGxnVmXXYx"
    private var networkController: NetworkController?
    
    init(network: Networking = Networking()) {
        self.network = network
        networkController = createNetworkController(network: network)
    }
    
    private func createNetworkController(network: Networking) -> NetworkController {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.yelp.com"
        return NetworkController(network: network)
                                .urlComponent(urlComponent)
                                .addValue("Authorization", value: "Bearer \(prodToken)")
    }
    
}

//MARK: - Business
extension YelpApi {
    // businesses/${businessId}
    public func business(id: String, completion: @escaping () -> Void) {
        let path = "/v3/businesses/\(id)"
        networkController?.urlComponentPath(path).responseDecodable(type: YelpBusiness.self) { (result) in
            switch result {
            case .success(_):
                print("SUCCESS")
            case .failure(let error):
                print("ERROR \(error)")
            }
        }
    }
}




//MARK: - Openings
extension YelpApi {
    // /bookings/${businessId}/openings
    // https://api.yelp.com/v3/bookings/rC5mIHMNF5C1Jtpb2obSkA/openings?covers=1&date=2020-09-09&time=06:30
    
    public func openings(id: String, covers: Int = 1, date:String, time: String) {
        let path = "/v3/businesses/\(id)/openings?covers=\(covers)&date=\(date)&time=\(time)"
        networkController?.urlComponentPath(path).responseDecodable(type: YelpOpen.self) { (result) in
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

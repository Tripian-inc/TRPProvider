//
//  YelpApi.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
public class YelpApi {
    
    var network: Networking?
    //TODO: TAŞINACAK
    private static let sandboxToken =
      "lKSyNooZ4m6EnK7530z9Enx2GAuym6UJxCwLVv82pjhB67LU_l89iQtfj-5pMasL7kt4AnjF_oW_gHAXiz84IQXcMLJVNFhc2aMRyd9YUAb3zv0K63voptIgbItlXXYx"
    
    //TODO: TAŞINACAK
    private static let prodToken =
      "SyqU9E_sGpBMUoViM6DBQkpLpRu5sCEvlqxs0-xAuTREuDoiIjf1TsPC-0PoWeK6O2_TSaDOdCoLMeoj5khI16DDMLqhvHSsFeTi9UHWwtTsu5kZBNOiHkBGxnVmXXYx"

    
    init(network: Networking = Networking()) {
        self.network = network
    }
    // businesses/${businessId}
    public func business(completion: @escaping () -> Void) {
        let request = createUrlRequest()
        network?.load(url: request, completion: { result in
            print("YELP SONUC GELDİ \(result)")
            
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(YelpBusiness.self, from: data!)
                    print("harika \(decodedData)")
                    completion()
                }
                catch {
                    print("Off fena parser error")
                }
            case .failure(let error):
                print("Off fena error \(error.localizedDescription)")
            }
        })
    }
    
    private func createUrlRequest(token: String = sandboxToken) -> URLRequest {
        let url = URL(string: "https://api.yelp.com/v3/businesses/gR9DTbKCvezQlqvD7_FzPw")
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

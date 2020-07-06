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
    private static let sandboxToken =
    "lKSyNooZ4m6EnK7530z9Enx2GAuym6UJxCwLVv82pjhB67LU_l89iQtfj-5pMasL7kt4AnjF_oW_gHAXiz84IQXcMLJVNFhc2aMRyd9YUAb3zv0K63voptIgbItlXXYx"
    
    //TODO: TAŞINACAK
    private static let prodToken =
    "SyqU9E_sGpBMUoViM6DBQkpLpRu5sCEvlqxs0-xAuTREuDoiIjf1TsPC-0PoWeK6O2_TSaDOdCoLMeoj5khI16DDMLqhvHSsFeTi9UHWwtTsu5kZBNOiHkBGxnVmXXYx"
    
    
    init(network: Networking = Networking()) {
        self.network = network
    }
    
    
    
}

//MARK: - Business
extension YelpApi {
    // businesses/${businessId}
    public func business(id: String, completion: @escaping () -> Void) {
        
        
    }
}


















//MARK: - Openings
extension YelpApi {
    // /bookings/${businessId}/openings
    // https://api.yelp.com/v3/bookings/rC5mIHMNF5C1Jtpb2obSkA/openings?covers=1&date=2020-09-09&time=06:30
    
    
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
    private func createUrlRequest(token: String = sandboxToken, url: String) -> URLRequest {
        let url = URL(string: url)
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.addValue("", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}



public protocol EvrenNetwork {
    
    associatedtype Output
    
    associatedtype Failure: Error
}


extension EvrenNetwork {
    
    
    
   
    
    /*
    extension Publishers {

        public struct Encode<Upstream: Publisher, Coder: TopLevelEncoder>: Publisher
            where Upstream.Output: Encodable
        {
            public typealias Failure = Error

            public typealias Output = Coder.Output

            public let upstream: Upstream

            private let _encode: (Upstream.Output) throws -> Output

            public init(upstream: Upstream, encoder: Coder) {
                self.upstream = upstream
                self._encode = encoder.encode
            }

            public func receive<Downstream: Subscriber>(subscriber: Downstream)
                where Failure == Downstream.Failure, Output == Downstream.Input
            {
                upstream.subscribe(Inner(downstream: subscriber, encode: _encode))
            }
        }

        public struct Decode<Upstream: Publisher, Output: Decodable, Coder: TopLevelDecoder>
            : Publisher
            where Upstream.Output == Coder.Input
        {
            public typealias Failure = Error

            public let upstream: Upstream

            private let _decode: (Upstream.Output) throws -> Output

            public init(upstream: Upstream, decoder: Coder) {
                self.upstream = upstream
                self._decode = { try decoder.decode(Output.self, from: $0) }
            }

            public func receive<Downstream: Subscriber>(subscriber: Downstream)
                where Failure == Downstream.Failure, Output == Downstream.Input
            {
                upstream.subscribe(Inner(downstream: subscriber, decode: _decode))
            }
        }
    }
    */
    
}


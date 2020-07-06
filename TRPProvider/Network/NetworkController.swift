//
//  NetworkController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 3.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

public typealias NetworkControllerResult<Success> = Result<Success, Error>

class NetworkController {
    
    let network: Networking
    private(set) var output: Data?
    private(set) var error: Error?
    
    public var baseUrl: String?
    
    
    init(network: Networking = Networking()) {
        self.network = network
    }
    
    @discardableResult
    private func request<T: Decodable>(queue: DispatchQueue = .main, type: T.Type) -> Self {
        let request = URLRequest(url: URL(string: "")!)
        network.load(url: request) { (result) in
            switch result {
            case .success(let data):
                do {
                    let converted = try JSONDecoder().decode(T.self, from: data!)
                    print("JSON RESULT \(converted)")
                }catch(let error){
                    print("JSON ERROR PARSER \(error)")
                }
                return
            case .failure(let error):
                print("NETWORK ERROR \(error)")
                return
            }
        }
        return self
    }
    
    
    @discardableResult
    func baseURL(url: String) -> Self {
        self.baseUrl = url
        return self
    }
    
    @discardableResult
    func responseDecodable<T: Decodable> (type: T.Type, completion: @escaping (NetworkControllerResult<T>) -> Void) -> Self {
        request(queue: .main, type: T.self)
        return self
    }
    
}

extension NetworkController {
    
    func url(_ url: URL) ->  NetworkController{
        return self
    }
    
    
    
    func addValue(_ key: String, forHTTPHeaderField: String) -> NetworkController {
        return self
    }
    
}

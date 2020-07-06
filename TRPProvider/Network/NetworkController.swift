//
//  NetworkController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 3.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}
public typealias NetworkControllerResult<Success> = Result<Success, Error>

class NetworkController {
    
    let network: Networking
    private(set) var output: Data?
    private(set) var error: Error?
    private(set) var url: URL?
    public var urlComponent: URLComponents?
    private(set) var allHTTPHeaderFields = [String:String]()
    private var request: URLRequest? {
        if let component = urlComponent, let componentUrl = component.url {
            var request = URLRequest(url: componentUrl)
            request.allHTTPHeaderFields = allHTTPHeaderFields
            return request
        }
        return URLRequest(url: url!)
    }
    
    
    init(network: Networking = Networking()){
        self.network = network
    }
    
    @discardableResult
    private func request<T: Decodable>(queue: DispatchQueue = .main, type: T.Type, completion: @escaping (NetworkControllerResult<T>) -> Void) -> Self {
        
        network.load(url: request!) { (result) in
            switch result {
            case .success(let data):
                do {
                    let converted = try JSONDecoder().decode(T.self, from: data!)
                    print("JSON RESULT \(converted)")
                    completion(.success(converted))
                }catch(let error){
                    print("JSON ERROR PARSER \(error)")
                    completion(.failure(error))
                }
                return
            case .failure(let error):
                print("NETWORK ERROR \(error)")
                completion(.failure(error))
                return
            }
        }
        return self
    }
    
    
    
    @discardableResult
    func responseDecodable<T: Decodable> (type: T.Type, completion: @escaping (NetworkControllerResult<T>) -> Void) -> Self {
        request(queue: .main, type: T.self, completion: completion)
        return self
    }
    
}

extension NetworkController {
    
    func url(_ url: URL) ->  NetworkController{
        self.url = url
        return self
    }
    
    @discardableResult
    func urlComponent(_ component: URLComponents) -> Self {
        urlComponent = component
        return self
    }
    
    @discardableResult
    func urlComponentPath(_ path: String) -> Self {
        urlComponent?.path = path
        return self
    }
    
    
    @discardableResult
    func addValue( _ key: String, value: String) -> Self {
        allHTTPHeaderFields[key] = value
        return self
    }
    
    
}
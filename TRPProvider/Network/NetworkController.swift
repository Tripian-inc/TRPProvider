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
    private(set) var url: URL?
    public var urlComponent: URLComponents?
    private(set) var allHTTPHeaderFields = [String:String]()
    private(set) var httpMethod: HttpMethod = .get
    private(set) var httpBody = [String: String]()
    
    
    private var request: URLRequest? {
        if let component = urlComponent, let componentUrl = component.url {
            var request = URLRequest(url: componentUrl)
            request.allHTTPHeaderFields = allHTTPHeaderFields
            request.httpMethod = httpMethod.rawValue
            if httpBody.count != 0 {
                request.httpBody = dictionaryToHttpBody(httpBody)
            }
            print(" ")
            print("!!!!!!!--------************************")
            print(request)
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
                let strongData = data
                GenericParser<T>().parse(data: strongData) { result in
                    switch result {
                    case .success(let decoded):
                        queue.async {
                            completion(.success(decoded!))
                        }
                    case .failure(let error):
                        queue.async {
                            self.readableJson(strongData!)
                            self.errorHandler(rawData: strongData, mainError: error, completion: completion)
                        }
                    }
                }
                return
            case .failure(let error):
                queue.async {
                    print("[Error] NETWORK \(error)")
                    completion(.failure(error))
                }
                return
            }
        }
        return self
    }
    
    
    private func readableJson(_ data: Data) {
        let result = String(data: data, encoding: .utf8)
        print(" ")
        print("-----------")
        print(" ")
        print(result!)
        print(" ")
        print("!!!!!!!!!!!!!!!")
        print(" ")
    }
    
    
    private func errorHandler<E: Decodable>(rawData:Data?, mainError: Error, completion: @escaping (NetworkControllerResult<E>) -> Void) {
        guard let data = rawData else {
            completion(.failure(mainError))
            return
        }
        
        GenericParser<YelpErrorResult>().parse(data: data) { result in
            switch result {
            case .success(let model):
                if let model = model {
                    let yelpError = YelpNetworkError(code: model.error.code, message: model.error.errorDescription)
                    completion(.failure(yelpError))
                }else {
                    completion(.failure(mainError))
                }
            case .failure(_):
                completion(.failure(mainError))
            }
        }
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
    func parameters(_ parameters: [String: String]) -> Self {
        urlComponent?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        return self
    }
    
    @discardableResult
    func bodyParameters(_ parameters: [String: String]) -> Self {
        httpBody = parameters
        return self
    }
    
    @discardableResult
    func httpMethod(_ type: HttpMethod) -> Self {
        httpMethod = type
        return self
    }
    
    
    @discardableResult
    func addValue( _ key: String, value: String) -> Self {
        allHTTPHeaderFields[key] = value
        return self
    }
    
  
    
}

extension NetworkController {
    
    func dictionaryToHttpBody(_ dictionary: [String: String]) -> Data? {
        var components = URLComponents()
        components.queryItems = httpBody.map{ URLQueryItem(name: $0.key, value: $0.value)}
        return components.query?.data(using: .utf8)
    }
    
}

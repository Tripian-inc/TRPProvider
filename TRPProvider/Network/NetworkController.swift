//
//  NetworkController.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 3.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

public typealias NetworkControllerResult<Success> = Result<Success, Error>

enum ProviderType {
    case yelp
    case gyg
}

class NetworkController {
    
    let network: Networking
    private(set) var output: Data?
    private(set) var error: Error?
    private(set) var url: URL?
    public var urlComponent: URLComponents?
    private(set) var allHTTPHeaderFields = [String:String]()
    private(set) var httpMethod: HttpMethod = .get
    private(set) var httpBody = [String: Any]()
    private(set) var httpBodyData: Data?
    public var provider: ProviderType = .yelp
    

    
    private var request: URLRequest? {
        if let component = urlComponent, let componentUrl = component.url {
            var request = URLRequest(url: componentUrl)
            request.allHTTPHeaderFields = allHTTPHeaderFields
            request.httpMethod = httpMethod.rawValue
            
            if let bodyData = httpBodyData {
                request.httpBody = bodyData
            }else if httpBody.count != 0 {
                request.httpBody = dictonaryToHttpData(httpBody)
            }
            
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
                        if data == nil {
                            print("DATA İS NİL")
                            //self.errorHandler(rawData: strongData, mainError: error, completion: completion)
                        }else {
                            
                        }
                        queue.async {
                            completion(.success(decoded!))
                        }
                    case .failure(let error):
                        queue.async {
                            print("Error \(error)")
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
        print("[Error] JsonDecoder \(result)")
    }
    
    
    private func errorHandler<E: Decodable>(rawData:Data?, mainError: Error, completion: @escaping (NetworkControllerResult<E>) -> Void) {
        guard let data = rawData else {
            completion(.failure(mainError))
            return
        }
        if provider == .yelp {
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
        }else if provider == .gyg {
            GenericParser<GYGErrorParser>().parse(data: data) { result in
                switch result {
                case .success(let model):
                    if let model = model {
                        if let error = model.errors.first {
                            let gygCustomError = GYGNetworkError(code:"\(error.errorCode)", message: error.errorMessage)
                            completion(.failure(gygCustomError))
                        }
                    }else {
                        completion(.failure(mainError))
                    }
                case .failure(_):
                    completion(.failure(mainError))
                }
            }
        }
       
    }
    
    
    @discardableResult
    func responseDecodable<T: Decodable> (type: T.Type, completion: @escaping (NetworkControllerResult<T>) -> Void) -> Self {
        //request(queue: .main, type: T.self, completion: completion)
        request(queue: .main, type: T.self,  completion: completion)
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
    
    func parameters(_ parameters: [URLQueryItem]) -> Self {
        urlComponent?.queryItems = parameters
        return self
    }
    
    
    @discardableResult
    func bodyParameters(_ parameters: [String: Any]) -> Self {
        httpBody = parameters
        return self
    }
    
    @discardableResult
    func bodyData<E: Encodable>(_ model: E) -> Self {
        httpBodyData = encodeData(model)
        return self
    }
    
    /*
    @discardableResult
    func bodyParameters<T: >(_ )
  */
    
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

    public func encodeData<E: Encodable>(_ model: E) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let result = try encoder.encode(model)
            return result
        }catch let error {
            print("[Error] JsonEncode \(error.localizedDescription)")
        }
        return nil
    }
    
    func dictonaryToHttpData(_ parameters: [String: Any]) -> Data? {
        do {
            let result = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return result
        } catch let error {
            print("[Error] JsonEncode \(error.localizedDescription)")
        }
        return nil
    }
}

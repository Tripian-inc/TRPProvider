//
//  Networking.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation

public protocol NetworkSession {
    //func load(from urlRequest: NSURLRequest, completionHandler: @escaping (Data?, Error?))
    func load(from urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void)
}


extension URLSession: NetworkSession {
    public func load(from urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        let task = dataTask(with: urlRequest) { (data, _, error) in
            completionHandler(data, error)
        }
        task.resume()
    }
}



public class Networking {
    
    
    private(set) var session: NetworkSession
    
    public init(session: NetworkSession = URLSession.shared) {
        
        self.session = session
    }
    
    public func load(url: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
        session.load(from: url) { (data, error) in
            if let error = error {
                completion(.failure(error))
            }else {
                print("[Info] Data \(String(data: data!, encoding: .utf8))")
                completion(.success(data))
            }
        }
    }
    
}

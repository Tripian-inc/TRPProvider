//
//  MockSession.swift
//  TRPProviderTests
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
@testable import TRPProvider
class MockSession: NetworkSession {
    
    var data: Data?
    var error: Error?
    
    func load(from urlRequest: URLRequest, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(self.data, self.error)
    }
    
}

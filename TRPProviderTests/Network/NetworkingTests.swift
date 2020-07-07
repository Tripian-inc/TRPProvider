//
//  NetworkingTests.swift
//  TRPProviderTests
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import XCTest
@testable import TRPProvider
class NetworkingTests: XCTestCase {

    var mockSession = MockSession()

    func testWithMockSession() throws {
        let url = URL(string: "https://api.yelp.com/v3/businesses/gR9DTbKCvezQlqvD7_FzPw")
        let urlRequest = URLRequest(url: url!)
        
        let network = Networking(session: mockSession)
        
        mockSession.data = "FakeJson".data(using: .utf8)
        
        network.load(url: urlRequest) { result in
            print("Mazinga")
            
            switch result {
            case .success(let resultData):
                XCTAssertEqual(resultData, self.mockSession.data)
            default:
                ()
            }
        }
        
    }

}

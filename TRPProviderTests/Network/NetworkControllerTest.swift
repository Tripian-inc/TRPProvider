
//
//  NetworkControllerTest.swift
//  TRPProviderTests
//
//  Created by Evren Yaşar on 6.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import XCTest
@testable import TRPProvider
class NetworkControllerTest: XCTestCase {
    
    func testNetworkControllerURL() {
        let expectation = XCTestExpectation()
        let url = URL(string: "https://www.google.com")!
        let controller = NetworkController().url(url)
        
        controller.responseDecodable(type: YelpBusiness.self) { (result) in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }

}

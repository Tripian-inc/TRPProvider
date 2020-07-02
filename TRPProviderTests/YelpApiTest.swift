//
//  YelpApiTest.swift
//  TRPProviderTests
//
//  Created by Evren Yaşar on 2.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import XCTest
@testable import TRPProvider
class YelpApiTest: XCTestCase {

    func testExample() throws {
        let expectation = XCTestExpectation()
        YelpApi().business {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }


}

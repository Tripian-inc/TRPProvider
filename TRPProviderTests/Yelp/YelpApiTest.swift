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
    
    
    //Product Token
    func testProductToken() {
        let yelpProduct = YelpApi(isProduct: true)
        XCTAssertEqual(yelpProduct.token, yelpProduct.productToken)
    }
    
    //SendBox Token
    func testSandboxToken() {
        let yelpProduct = YelpApi(isProduct: false)
        XCTAssertEqual(yelpProduct.token, yelpProduct.sandboxToken)
    }
    
    //Boş data ile hata yakalanır.
    func testNetworkSessionWithError() throws {
        let expectation = XCTestExpectation()
        
        let fakeData = "FakeData".data(using: .utf8)
        
        let mockSession = MockSession()
        mockSession.data = fakeData
        let mockNetwork = Networking(session: mockSession)
        let yelpApi = YelpApi(network: mockNetwork)
        
        yelpApi.business(id: "") { (result) in
            switch result {
            case .failure(let error):
                XCTAssertNotNil(error)
            case .success(_):
                XCTFail("Yelp Business Result mode dönmemeli")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    
    
    
    func testBusiness() {
        guard let jsonData = FileReader().json("test_business") else {
            XCTFail("model is nil")
            return
        }
        
        let expectation = XCTestExpectation()
        let mockSession = MockSession()
        mockSession.data = jsonData
        let mockNetwork = Networking(session: mockSession)
        let yelpApi = YelpApi(network: mockNetwork)
        yelpApi.business(id: "") { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    
    
    
    
}

//REAL CALL
extension YelpApiTest {
    
    func testBusinessCall() {
        let expectation = XCTestExpectation()
        let yelpApi = YelpApi( isProduct: false)
        yelpApi.business(id: "rC5mIHMNF5C1Jtpb2obSkA") { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
}

// MOCK CALL
extension YelpApiTest {
    
    func testBusinessWithMockData() {
        guard let jsonData = FileReader().json("test_business") else {
            XCTFail("model is nil")
            return
        }
        
        let expectation = XCTestExpectation()
        let mockSession = MockSession()
        mockSession.data = jsonData
        let mockNetwork = Networking(session: mockSession)
        let yelpApi = YelpApi(network: mockNetwork)
        yelpApi.business(id: "") { (result) in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(_):
                XCTAssert(true)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
}

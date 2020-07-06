//
//  NetworkControllerWithComponentTest.swift
//  TRPProviderTests
//
//  Created by Evren Yaşar on 6.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import XCTest
@testable import TRPProvider
class NetworkControllerWithComponentTest: XCTestCase {

    private let productToken =
    "SyqU9E_sGpBMUoViM6DBQkpLpRu5sCEvlqxs0-xAuTREuDoiIjf1TsPC-0PoWeK6O2_TSaDOdCoLMeoj5khI16DDMLqhvHSsFeTi9UHWwtTsu5kZBNOiHkBGxnVmXXYx"

    var controller: NetworkController?
    
    override func setUp() {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.yelp.com"
        
        controller = NetworkController()
            .urlComponent(urlComponent)
            .addValue("Authorization", value: "Bearer \(productToken)")
    }
    
    func testBusiness() {
        let expectation = XCTestExpectation()
        controller!.urlComponentHost("/v3/businesses/gR9DTbKCvezQlqvD7_FzPw").responseDecodable(type: YelpBusiness.self) { (result) in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }

}

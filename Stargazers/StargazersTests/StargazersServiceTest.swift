//
//  StargazersServiceTest.swift
//  StargazersTests
//
//  Created by Marco Iacobelli on 21/07/22.
//

import XCTest
import Moya

@testable import Stargazers
class StargazersServicTests: XCTestCase {

    func testRealRequest() {
        let client = StargazerClient(provider: MoyaProvider<StargazerNetwork>())
        let testExpectation = expectation(description: "http request")
        
        client.stargazers(owner: "Nocodb", repo: "Nocodb", perPage: 1, page: 1) { result in
            XCTAssertNotNil(try? result.get())
            testExpectation.fulfill()
        }
        
        wait(for: [testExpectation], timeout: 5.0)
    }

}

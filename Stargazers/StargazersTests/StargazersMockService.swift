//
//  StargazersMockService.swift
//  StargazersTests
//
//  Created by Marco Iacobelli on 21/07/22.
//

import XCTest
@testable import Stargazers

class StargazersMockService: StargazerService {
    private var stargazersOwner: String?
    private var stargazersRepo: String?
    private var stargazersPerPage: Int?
    private var stargazersPage: Int?
    private var stargazersResult: Result<[Stargazer], StargazerServiceError>?
    
    func assertStargazersWith(owner: String, repo: String, perPage: Int, page: Int) {
        XCTAssertEqual(self.stargazersOwner, owner)
        XCTAssertEqual(self.stargazersRepo, repo)
        XCTAssertEqual(self.stargazersPerPage, perPage)
        XCTAssertEqual(self.stargazersPage, page)
    }
    
    func whenStargazerReturn(list: Result<[Stargazer], StargazerServiceError>) {
        self.stargazersResult = list
    }
    
    func stargazers(owner: String, repo: String, perPage: Int, page: Int, completion: @escaping (Result<[Stargazer], StargazerServiceError>) -> Void) {
        self.stargazersOwner = owner
        self.stargazersRepo = repo
        self.stargazersPerPage = perPage
        self.stargazersPage = page
        
        if let result = stargazersResult {
            completion(result)
        }
    }

}

//
//  StargazerhubService.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import Moya

protocol StargazerService {
    func stargazers(owner: String, repo: String, perPage: Int, page: Int, completion: @escaping (Result<[Stargazer], StargazerServiceError>) -> Void)
}

class StargazerClient: StargazerService {
    private let provider: MoyaProvider<StargazerNetwork>
    
    init (provider: MoyaProvider<StargazerNetwork>) {
        self.provider = provider
    }
    
    func stargazers(owner: String, repo: String, perPage: Int, page: Int, completion: @escaping (Result<[Stargazer], StargazerServiceError>) -> Void) {
        provider.request(.stargazers(owner: owner, repo: repo, perPage: perPage, page: page)) { result in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 404:
                    completion(.failure(.repositoryNotFound))
                case 200:
                    guard let list: [Stargazer] = try? response.map([Stargazer].self) else {
                        completion(.failure(.genericError))
                        return
                    }
                    completion(.success(list))
                default: completion(.failure(.genericError))
                }
            case .failure:
                completion(.failure(.genericError))
            }
        }
    }
    
}

enum StargazerServiceError: Error {
    case repositoryNotFound
    case genericError
    
    var errorDescription: String {
        get {
            switch self {
            case .genericError: return "An error occurred, retry later..."
            case .repositoryNotFound: return "404 | Repository not found"
            }
        }
    }
}


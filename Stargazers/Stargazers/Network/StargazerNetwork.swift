//
//  StargazerNetwork.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//
import Moya

enum StargazerNetwork {
    case stargazers(owner: String, repo: String, perPage: Int, page: Int)
}

extension StargazerNetwork: TargetType {
    var baseURL: URL { URL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case .stargazers(let owner, let repo, _, _):
            return "/repos/\(owner)/\(repo)/stargazers"
        }
    }
    
    var method: Method {
        switch self {
        case .stargazers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .stargazers(_,_, let perPage, let page):
            return .requestParameters(parameters: ["per_page": perPage, "page": page], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        ["Content-type": "application/json"]
        //["Content-type": "application/json"], "Authorization": "Bearer YOUR_API_KEY"]
    }
    
}

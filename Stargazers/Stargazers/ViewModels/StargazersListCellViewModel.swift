//
//  StargazersListCellViewModel.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import Foundation

struct StargazersListCellViewModel: Equatable {
    
    //MARK:- Variable:-
    let avatar_url: String?
    let login: String?
    
}

extension StargazersListCellViewModel {
    
    init(stargazer: Stargazer) {
        self.avatar_url = stargazer.avatarUrl
        self.login = stargazer.name 
    }
    
}

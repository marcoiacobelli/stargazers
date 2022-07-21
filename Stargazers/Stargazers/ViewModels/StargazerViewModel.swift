//
//  StargazerViewModel.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import Combine

class StargazerViewModel: ObservableObject {
    private let service: StargazerService
    var cellViewModels: [StargazersListCellViewModel]
    
    @Published private(set) var state: State
    
    init(service: StargazerService, state: State = State(), cellViewModels:  [StargazersListCellViewModel])  {
        self.service = service
        self.state = state
        self.cellViewModels = []
    }
    
    func didFormSubmit(owner: String, repo: String) {
        state.message = "Loading..."
        state.owner = owner
        state.repo = repo
        state.allDataLoaded = false
        state.list = nil
        state.error = nil
        state.isLoading = true
        fetchStargazers {
            self.state.isLoading = false
        }
    }
    
    func loadMore() {
        fetchStargazers {}
    }
    
    func reset() {
        state.owner = ""
        state.repo = ""
        state.allDataLoaded = false
        state.list = nil
        state.message = "Tap '+' to start a new repo check"
        state.error = nil
        
        self.cellViewModels = []
    }

    private func fetchStargazers(completion: @escaping () -> Void) {
        service.stargazers(owner: state.owner, repo: state.repo, perPage: RESULTS_PER_PAGE, page: nextPage()) { [weak self] result in
            guard let self = self else { return }
            
            defer {
                completion()
            }
            
            switch result {
            case .success(let stargazers):
                if self.state.list == nil {
                    self.state.list = []
                    self.cellViewModels = []
                    self.state.message = "Nobody loves this repository :("
                }
                
                if stargazers.count < self.RESULTS_PER_PAGE {
                    self.state.allDataLoaded = true
                }
                
                self.state.list! += stargazers
                self.cellViewModels += stargazers.map(StargazersListCellViewModel.init)

            case .failure(let error):
                self.state.error = error.errorDescription
            }
        }
    }
    
    private func nextPage() -> Int {
        guard let count =  state.list?.count else {
            return 1
        }
        
        return (count / RESULTS_PER_PAGE) + 1
    }
    
    private let  RESULTS_PER_PAGE = 10
}

extension StargazerViewModel {
    struct State {
        var owner = ""
        var repo = ""
        var allDataLoaded = false
        var list: [Stargazer]?
        var message = "Tap '+' to start a new repo check"
        var error: String?
        var isLoading = false
    }
}

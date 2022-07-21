//
//  StargazersViewModelTests.swift
//  StargazersTests
//
//  Created by Marco Iacobelli on 21/07/22.
//

import XCTest
@testable import Stargazers

class StargazersViewModelTests: XCTestCase {
    private var service: StargazersMockService!
    private var viewModel: StargazerViewModel!
    
    override func setUp() {
        service = StargazersMockService()
    }
    
    private func initViewModel(with state: StargazerViewModel.State) {
        viewModel = StargazerViewModel(service: service, state: state, cellViewModels: [])
    }

    func testDidFormSubmit_success_allDataLoaded() {
        let expectedList = subList(from: 0, to: 1)
        let expectedRows = subListCell(from: 0, to: 1)
        initViewModel(with: StargazerViewModel.State())
        viewModel.cellViewModels = expectedList.map(StargazersListCellViewModel.init)
        service.whenStargazerReturn(list: .success(expectedList))
        
        viewModel.didFormSubmit(owner: "testOwner", repo: "testRepo")
        
        service.assertStargazersWith(owner: "testOwner", repo: "testRepo", perPage: 10, page: 1)
        XCTAssertEqual("testOwner", viewModel.state.owner)
        XCTAssertEqual("testRepo", viewModel.state.repo)
        XCTAssertEqual(expectedList, viewModel.state.list)
        XCTAssertEqual(expectedRows, viewModel.cellViewModels)
        XCTAssertTrue(viewModel.state.allDataLoaded)
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual("Nobody loves this repository :(", viewModel.state.message)
        
    }
    
    func testDidFormSubmit_success_partialDataLoaded() {
        let expectedList = subList(from: 0, to: 9)
        let expectedRows = subListCell(from: 0, to: 9)
        initViewModel(with: StargazerViewModel.State())
        viewModel.cellViewModels = expectedList.map(StargazersListCellViewModel.init)
        service.whenStargazerReturn(list: .success(expectedList))
        
        viewModel.didFormSubmit(owner: "testOwner", repo: "testRepo")
        
        service.assertStargazersWith(owner: "testOwner", repo: "testRepo", perPage: 10, page: 1)
        XCTAssertEqual("testOwner", viewModel.state.owner)
        XCTAssertEqual("testRepo", viewModel.state.repo)
        XCTAssertEqual(expectedList, viewModel.state.list)
        XCTAssertEqual(expectedRows, viewModel.cellViewModels)
        XCTAssertFalse(viewModel.state.allDataLoaded)
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual("Nobody loves this repository :(", viewModel.state.message)

    }
    
    func testLoadingWhenFormDidSubmit() {
        initViewModel(with: StargazerViewModel.State())
        
        viewModel.didFormSubmit(owner: "testOwner", repo: "testRepo")
        
        XCTAssertTrue(viewModel.state.isLoading)
    }

    func testDidFormSubmit_error() {
        initViewModel(with: StargazerViewModel.State())
        service.whenStargazerReturn(list: .failure(.genericError))
        
        viewModel.didFormSubmit(owner: "testOwner", repo: "testRepo")
        
        service.assertStargazersWith(owner: "testOwner", repo: "testRepo", perPage: 10, page: 1)
        XCTAssertEqual("testOwner", viewModel.state.owner)
        XCTAssertEqual("testRepo", viewModel.state.repo)
        XCTAssertNil(viewModel.state.list)
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertEqual(StargazerServiceError.genericError.errorDescription, viewModel.state.error)
        XCTAssertEqual("Loading...", viewModel.state.message)

    }
    
    func testLoadMore_success_allDataLoaded() {
        let alreadyLoadedList = subList(from: 0, to: 9)
        let alreadyAddedRows = subListCell(from: 0, to: 9)
        let expectedList = subList(from: 10, to: 11)
        let expectedRows = subListCell(from: 10, to: 11)
        let state = StargazerViewModel.State(owner: "testOwner", repo: "testRepo", allDataLoaded: false, list: alreadyLoadedList)
        initViewModel(with: state)
        viewModel.cellViewModels = alreadyLoadedList.map(StargazersListCellViewModel.init)
        service.whenStargazerReturn(list: .success(expectedList))
        
        viewModel.loadMore()
        
        service.assertStargazersWith(owner: "testOwner", repo: "testRepo", perPage: 10, page: 2)
        XCTAssertEqual("testOwner", viewModel.state.owner)
        XCTAssertEqual("testRepo", viewModel.state.repo)
        XCTAssertEqual(alreadyLoadedList + expectedList, viewModel.state.list)
        XCTAssertEqual(alreadyAddedRows + expectedRows, viewModel.cellViewModels)
        XCTAssertTrue(viewModel.state.allDataLoaded)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual("Tap '+' to start a new repo check", viewModel.state.message)

    }
    
    func testReset() {
        let alreadyLoadedList: [Stargazer] = subList(from: 0, to: 9)
        let expectedRows: [StargazersListCellViewModel] = []
        let state = StargazerViewModel.State(owner: "testOwner", repo: "testRepo", allDataLoaded: true, list: alreadyLoadedList)
        initViewModel(with: state)
        viewModel.cellViewModels = alreadyLoadedList.map(StargazersListCellViewModel.init)
        
        viewModel.reset()
       
        XCTAssertTrue(viewModel.state.owner.isEmpty)
        XCTAssertTrue(viewModel.state.repo.isEmpty)
        XCTAssertNil(viewModel.state.list)
        XCTAssertEqual(expectedRows, viewModel.cellViewModels)
        XCTAssertFalse(viewModel.state.allDataLoaded)
        XCTAssertNil(viewModel.state.error)
        XCTAssertEqual("Tap '+' to start a new repo check", viewModel.state.message)

    }
    
    private func subList(from: Int, to: Int) -> [Stargazer] {
        Array(fullList[from...to])
    }
    
    private let fullList = [
        Stargazer(id: 0, name: "a", avatarUrl: "url"),
        Stargazer(id: 1, name: "b" , avatarUrl: "url"),
        Stargazer(id: 2, name: "c" , avatarUrl: "url"),
        Stargazer(id: 3, name: "d" , avatarUrl: "url"),
        Stargazer(id: 4, name: "e" , avatarUrl: "url"),
        Stargazer(id: 5, name: "f" , avatarUrl: "url"),
        Stargazer(id: 6, name: "g" , avatarUrl: "url"),
        Stargazer(id: 7, name: "h" , avatarUrl: "url"),
        Stargazer(id: 8, name: "i" , avatarUrl: "url"),
        Stargazer(id: 9, name: "l" , avatarUrl: "url"),
        Stargazer(id: 10, name: "m" , avatarUrl: "url"),
        Stargazer(id: 11, name: "n" , avatarUrl: "url"),
        Stargazer(id: 12, name: "o" , avatarUrl: "url"),
        Stargazer(id: 13, name: "p" , avatarUrl: "url"),
        Stargazer(id: 14, name: "q" , avatarUrl: "url"),
        Stargazer(id: 15, name: "r" , avatarUrl: "url"),
        Stargazer(id: 16, name: "s" , avatarUrl: "url"),
        Stargazer(id: 17, name: "t" , avatarUrl: "url"),
        Stargazer(id: 18, name: "u" , avatarUrl: "url"),
        Stargazer(id: 19, name: "v" , avatarUrl: "url")
    ]
    
    private func subListCell(from: Int, to: Int) -> [StargazersListCellViewModel] {
        Array(fullListCellViewModel[from...to])
    }
    
    private let fullListCellViewModel = [
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 0, name: "a", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 1, name: "b", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 2, name: "c", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 3, name: "d", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 4, name: "e", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 5, name: "f", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 6, name: "g", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 7, name: "h", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 8, name: "i", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 9, name: "l", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 10, name: "m", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 11, name: "n", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 12, name: "o", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 13, name: "p", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 14, name: "q", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 15, name: "r", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 16, name: "s", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 17, name: "t", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 18, name: "u", avatarUrl: "url")),
        StargazersListCellViewModel.init(stargazer: Stargazer(id: 19, name: "v", avatarUrl: "url")),
        
    ]
    
}

//
//  StargazersListViewController.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import UIKit
import Moya
import Combine

class StargazersListViewController: UIViewController {

    //MARK:- Layout:-
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var statusLabel: UILabel!
    var viewModel: StargazerViewModel?
    var subscriptions = [AnyCancellable]()
    var canLoadMore: Bool = false

    //MARK:- Actions-
    @IBAction func btnAddAction(_ sender: Any) {
        setupDialog()
    }
    
    //MARK:- Life Cycle:-
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        viewModel!.$state
           .receive(on: DispatchQueue.main)
           .sink { [weak self] items in
               self?.statusLabel.text = items.message
               if(items.list != nil) { self!.setupTitle(navTitle: items.owner + "/" + items.repo) }
               if(items.isLoading == false && items.list != nil && items.allDataLoaded == false) { self?.canLoadMore = true; self!.updateItems()}
               if(items.isLoading == false && items.list != nil && items.allDataLoaded == true) { self?.canLoadMore = false; self!.updateItems() }
               if((items.error) != nil){ self!.statusLabel.text = items.error; self!.setupTitle(navTitle: "Stargazers")}
           }
           .store(in: &subscriptions)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigation()
        setupTitle(navTitle: "Stargazers")
    }
    
    // MARK: - Private
    private func addAccessibilityIdentifier() {
        tableView.accessibilityIdentifier = StargazerSceneAccessibilityIdentifier.stargazerTableView
    }
    
    private func setupViews() {
        addAccessibilityIdentifier()
        self.tableView.reloadData()
    }
    
    private func reset() {
        addAccessibilityIdentifier()
        self.canLoadMore = false
        self.viewModel?.reset()
    }
    
    private func setupDialog(){
            
            let alertController = UIAlertController(title: "New Search", message: "Please enter Owner and Repository name.", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "Check for Stargazers", style: .default) { (_) in
                let owner = alertController.textFields?[0].text
                let repo = alertController.textFields?[1].text
                self.reset()
                self.viewModel!.didFormSubmit(owner: owner!, repo: repo!)
            }
        
            confirmAction.accessibilityIdentifier = AccessibilityIdentifier.confirmBtn
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            cancelAction.accessibilityIdentifier = AccessibilityIdentifier.cancelBtn
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Owner"
                textField.accessibilityIdentifier = AccessibilityIdentifier.ownerField
            }
            alertController.addTextField { (textField) in
                textField.placeholder = "Repository"
                textField.accessibilityIdentifier = AccessibilityIdentifier.repoField
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : AppTheme.agidBlue ?? UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : AppTheme.agidBlue ?? UIColor.black]
        navigationController?.navigationBar.tintColor = AppTheme.agidBlue
    }
    
    private func setupTitle(navTitle: String){
        self.navigationItem.title = navTitle
    }
    
    private func updateItems() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if self.tableView.visibleCells.isEmpty {
                self.statusLabel.isHidden = false }
            else {
                self.statusLabel.isHidden = true }
            }
    }
    
}

//MARK:- UITableViewDataSource
extension StargazersListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StargazerTableCell.reuseIdentifier) as! StargazerTableCell
        cell.cellViewModel = viewModel?.cellViewModels[indexPath.row]
        return cell
    }

}

//MARK:- UITableViewDelegate
extension StargazersListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        ((viewModel?.cellViewModels.isEmpty) != nil)
                                          ? StargazerTableCell.height
                                          : self.tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (viewModel?.cellViewModels.count)! - 1 {
            if(self.canLoadMore){
                self.viewModel!.loadMore()
            }
        }
    }
    
}

//MARK:- Orientation
extension StargazersListViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

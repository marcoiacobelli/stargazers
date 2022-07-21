//
//  StargazerTableCell.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import UIKit

class StargazerTableCell: UITableViewCell {
    static let reuseIdentifier = String(describing: StargazerTableCell.self)
    static let height = CGFloat(65)
    
    //MARK:- Layout:-
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var stargazerLoginLabel: UILabel!
    
    //MARK:- View Model Stargazer cell
    var cellViewModel: StargazersListCellViewModel? {
        didSet {
            self.setup()
        }
    }
}


//MARK:- Network:-
extension StargazerTableCell {

    //MARK:- Setup & Load Data
    fileprivate func setup(){
        let avatarImageUrl = (cellViewModel?.avatar_url ?? "")
        avatarImageView.loadImage(urlString: avatarImageUrl)
        stargazerLoginLabel.text = cellViewModel?.login
    }
}

//
//  UIImageView+Extension.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func loadImage(urlString: String?){
        
        if urlString != nil {
            self.alpha = 0.0
            self.sd_setImage(with: URL(string: urlString!), placeholderImage: UIImage(named: "defaultIMG"), options: .highPriority, progress: { (value, toValue, nil) in
            }) { (_, _, _, _) in
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.alpha = 1.0
                    self?.layoutIfNeeded()
                }
            }
        }else {
            self.image = UIImage(named: "defaultIMG")
        }
    }
}

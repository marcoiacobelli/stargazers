//
//  Colors.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import UIKit

struct DesignSystem {
    
    enum Colors: String {
        case primary = "primary"
        case secondary = "secondary"
        case darkLine = "darkLine"
        case pinkColor = "pinkColor"
        case bgColor = "bgColor"
        case blueColor = "blueColor"
        case headerBGColor = "headerBGColor"
        case whiteColor = "whiteColor"
        
        var color: UIColor {
            return UIColor(named: self.rawValue)!
        }
    }
}

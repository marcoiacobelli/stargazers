//
//  Font.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import UIKit

enum Font: String {
    
    case regular = "AvenirNext-Regular"
    case semiBold = "AvenirNext-DemiBold"
    case meduim = "AvenirNext-Medium"
    case bold = "AvenirNext-Bold"
    
    var name: String { self.rawValue }
}

enum FontSize: CGFloat {
    case size_s = 10
    case size_m = 12
    case size_l = 14
    case size_xl = 16
    case size_2xl = 20
    
    var size: CGFloat {
        if  (UIDevice.current.userInterfaceIdiom == .pad) {
            return self.rawValue * 2
        }
        return self.rawValue
    }
}

extension UIFont {
    class func fonts(name: Font , size: FontSize) -> UIFont {
        return UIFont(name: name.name, size: size.size) ?? UIFont()
    }
}

//
//  ViewControllerUtilities.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import UIKit

enum Storyboard: String {
    case main = "Stargazers"
}

protocol ViewControllerUtilities where Self: UIViewController {
    static func initialize(on storyboard: Storyboard) -> Self
}

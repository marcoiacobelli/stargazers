//
//  AppContainer.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import Foundation
import UIKit

class AppContainer {
    
    func startApp(on window: UIWindow?) {
        let module = StargazerModule()
        let controller = module.createStargazerViewController()
        let nvc: UINavigationController = UINavigationController(rootViewController: controller)
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
    
}

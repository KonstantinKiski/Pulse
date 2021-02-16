//
//  Router.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 1/4/21.
//

import UIKit


final class Router {
    public static let shared = Router()
    var mainNavigationVC: UINavigationController?
    var hasLaunchedFirst: Bool = false
    
    private init() {}
    
    func popToRoot(animated: Bool = false) {
        mainNavigationVC?.popToRootViewController(animated: animated)
    }
    
    func openMainPage(animated: Bool = true) {
        let tabbarVC = MainTabbarController()
        self.mainNavigationVC?.pushViewController(tabbarVC, animated: animated)
    }
}


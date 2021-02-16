//
//  MainTabBarController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 1/4/21.
//

import Foundation
import UIKit

class MainTabbarController: UITabBarController {
    
    let tabbar1 = UITabBarItem(title: PulseTabsName.history, image: R.image.bar_history(), selectedImage: R.image.bar_history())
    let tabbar2 = UITabBarItem(title: PulseTabsName.diet, image: R.image.bar_diet(), selectedImage: R.image.bar_diet())
    let tabbar3 = UITabBarItem(title: PulseTabsName.heart, image: R.image.bar_heart(), selectedImage: R.image.bar_heart())
    let tabbar4 = UITabBarItem(title: PulseTabsName.pressure, image: R.image.bar_pressure(), selectedImage: R.image.bar_pressure())
    let tabbar5 = UITabBarItem(title: PulseTabsName.settings, image: R.image.bar_settings(), selectedImage: R.image.bar_settings())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: PulseFont.bold(10)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: PulseFont.bold(10)!], for: .selected)
        self.title = "History"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationItem.setHidesBackButton(false, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: false)
        guard let firstVC = R.storyboard.history.instantiateInitialViewController(),
              let secondVC = R.storyboard.diet.instantiateInitialViewController(), let threeVC = R.storyboard.heartRateKit.instantiateInitialViewController(), let fourtVC = R.storyboard.pressure.instantiateInitialViewController(), let fifthVC = R.storyboard.settings.instantiateInitialViewController() else {
            super.viewWillAppear(animated)
            return
        }

        firstVC.modalPresentationStyle = .fullScreen
        firstVC.tabBarItem = tabbar1
        
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.tabBarItem = tabbar2
        
        threeVC.modalPresentationStyle = .fullScreen
        threeVC.tabBarItem = tabbar3
        
        fourtVC.modalPresentationStyle = .fullScreen
        fourtVC.tabBarItem = tabbar4
        
        fifthVC.modalPresentationStyle = .fullScreen
        fifthVC.tabBarItem = tabbar5
        
        self.setViewControllers([firstVC, secondVC, threeVC, fourtVC, fifthVC], animated: true)
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = PulseColor.red
        self.selectedIndex = 2
        super.viewWillAppear(animated)
    }

    @objc func adsAction() {
        
    }
}

enum PulseTabsName {
    static let history = "History"
    static let diet = "Dash Diet"
    static let heart = "Heart Rate"
    static let pressure = "Pressure"
    static let settings = "Settings"
}



//extension MainTabbarController: UITabBarControllerDelegate {
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        <#code#>
//    }
//}
//

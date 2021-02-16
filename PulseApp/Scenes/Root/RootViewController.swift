//
//  RootViewController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 1/4/21.
//

import UIKit


class RootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = PulseColor.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Router.shared.mainNavigationVC = self.navigationController
        routeToMain()
    }
    
    private func routeToMain() {
        Router.shared.openMainPage()
    }
}

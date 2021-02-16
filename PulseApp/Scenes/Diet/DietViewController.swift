//
//  DietViewController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.
//

import UIKit

class DietViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = PulseColor.background
        self.title = PulseTabsName.diet
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

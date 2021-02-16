//
//  HeartRateTagsController.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 10/01/21.
//

import UIKit

class HeartRateTagsController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tagButton1: UIButton!
    @IBOutlet weak var tagButton2: UIButton!
    @IBOutlet weak var tagButton3: UIButton!
    @IBOutlet weak var tagButton4: UIButton!
    @IBOutlet weak var tagButton5: UIButton!
    @IBOutlet weak var tagButton6: UIButton!
    @IBOutlet weak var tagButton7: UIButton!
    @IBOutlet weak var tagButton8: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        PulseViewSetting.setupSystemButton(&cancelButton, title: "Cancel")
        let tagsButton = [tagButton1, tagButton2, tagButton3, tagButton4, tagButton5, tagButton6, tagButton7, tagButton8]
        tagsButton.forEach { (btn) in
            btn?.layer.borderWidth = 1
            btn?.layer.borderColor = #colorLiteral(red: 0.4952989131, green: 0.4952989131, blue: 0.4952989131, alpha: 0.5)
        }
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
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

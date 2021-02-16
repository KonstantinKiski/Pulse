//
//  DefaultTableViewCell.swift
//  Bricket
//
//  Created by Константин Киски on 24.09.2020.
//

import Foundation
import UIKit

class DefaultTableViewCell: UITableViewCell {
    
    struct Data {
        var title: String?
        var text: String?
        var buttonTitle: String?
        var image: String?
    }
    
    @IBOutlet private weak var titleCell: UILabel?
    @IBOutlet private weak var subtitleCell: UILabel?
    @IBOutlet private weak var imageCell: UIImageView?
    @IBOutlet private weak var defaultButton: UIButton?
    @IBOutlet private weak var mainView: UIView!
    
    private var controller: UIViewController?
    private var currentItem: NewsCollectionCell.ItemNews?
    
    func setData(data: Data) {
        titleCell?.text = data.title
        subtitleCell?.text = data.text
        defaultButton?.setTitle(data.buttonTitle, for: .normal)
    }
    
    func setDataWithAction(data: NewsCollectionCell.ItemNews, controller: UIViewController) {
        titleCell?.text = data.title
        subtitleCell?.text = data.text
        self.controller = controller
        self.currentItem = data
    }
    
    func setBorderColor(color: UIColor) {
        mainView.layer.borderColor = color.cgColor
    }
}

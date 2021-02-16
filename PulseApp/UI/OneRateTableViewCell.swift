//
//  OneRateTableViewCell.swift
//  PulseApp
//
//  Created by Константин Киски on 16.02.2021.
//

import Foundation
import UIKit

class OneRateTableViewCell: DefaultTableViewCell {
    
    // MARK: - UI Elements
    
    @IBOutlet private weak var oneRateView: OneRateView!
    
    // MARK: - Set data
    public func setData(date: Date, pulse: Int, icon: UIImage) {
        oneRateView.setData(date: date, pulse: pulse, icon: icon)
    }
}

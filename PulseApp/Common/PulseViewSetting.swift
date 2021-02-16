//
//  PulseViewSettings.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.
//

import UIKit

enum PulseViewSetting {
    static public func setupSystemButton(_ button: inout UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = PulseColor.red
        button.titleLabel?.font = PulseFont.medium(18)
        button.layer.cornerRadius = 20
    }
}

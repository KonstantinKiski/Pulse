//
//  PulseFonts.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.
//

import UIKit

enum PulseFont {
    
    static public func bold(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GothamPro-Bold", size: sizeDependedFontSize(fontSize))
    }

    static public func medium(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GothamPro-Medium", size: sizeDependedFontSize(fontSize))
    }
    
    static public func black(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GothamPro-Black", size: sizeDependedFontSize(fontSize))
    }

    static public func light(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GothamPro-Light", size: sizeDependedFontSize(fontSize))
    }
    
    static public func regular(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GothamPro", size: sizeDependedFontSize(fontSize))
    }

    static public func italic(_ fontSize: CGFloat) -> UIFont? {
        return UIFont(name: "GothamPro-Italic", size: sizeDependedFontSize(fontSize))
    }

    static private func sizeDependedFontSize(_ fontSize: CGFloat) -> CGFloat {
        switch PulseDevice.getDeviceSize {
        case .middle, .x:
            return 1.0 * fontSize
        case .big:
            return 1.2 * fontSize
        default:
            return fontSize
        }
    }
}

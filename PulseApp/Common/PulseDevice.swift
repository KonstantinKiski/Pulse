//
//  PulseDevice.swift
//  PulseApp
//
//  Created by Viacheslav Tolstopiatenko on 5/01/21.
//

import UIKit


final class PulseDevice {
    enum Size {
        case small
        case middle
        case big
        case x
    }
    
    static var getDeviceSize: Size = {
        let screenWidth  = UIScreen.main.fixedCoordinateSpace.bounds.width
        let screenHeight = UIScreen.main.fixedCoordinateSpace.bounds.height
        if screenWidth == 375 {
            if screenHeight == 812 {
                return .x
            }
            return .middle
        }
        if screenWidth == 414 {
            return .big
        }
        return .small
    }()
}

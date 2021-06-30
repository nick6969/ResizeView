//
//  UIColorExtension.swift
//  ResizeView
//
//  Created by nick on 2021/6/28.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff,
                  green: (netHex >> 8) & 0xff,
                  blue: netHex & 0xff)
    }
    
    static func colorWith(dark: UIColor, light: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { trait -> UIColor in
                return trait.userInterfaceStyle == .dark ? dark : light
            }
        } else {
            return light
        }
    }
    
}

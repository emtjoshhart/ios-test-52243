//
//  UIColor+DF.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/16/23.
//

import UIKit

extension UIColor {
    class var slateBlue: UIColor { UIColor.hex(0x3D4E6A) }
    class var babyBlue: UIColor { UIColor.hex(0xBDDAE4) }
    class var midnightBlue: UIColor { .hex(0x1D283B)}
    class var snowWhite: UIColor { .hex(0xF5FEFD)}
    class var stormCloud: UIColor { .hex(0x535F75)}
    class var lightestGray: UIColor { .hex(0xF7F7F7) }
    class var pastelBlue: UIColor { .hex(0xBDDAE4)}
    class var appYellow: UIColor { .hex(0xFDB100) }
    class var appPink: UIColor { .hex(0xF61985) }
    class var appTeal: UIColor { .hex(0x00C4B1) }
    class var appPurple: UIColor { .hex(0xB81985) }

    /// Returns UIColor object with provided RGB value.
    /// - Parameter fromRGB: Integer hex value of RGB.
    /// - Returns: Returns UIColor object based on RGB value.
    static func hex(_ hex: Int) -> UIColor {
        return UIColor(red: CGFloat((hex & 0xFF0000) >> 16) / CGFloat(255),
                       green: CGFloat((hex & 0x00FF00) >> 8) / CGFloat(255),
                       blue: CGFloat(hex & 0x0000FF) / CGFloat(255),
                       alpha: 1.0)
    }

    var coreImageColor: CIColor { CIColor(color: self) }

    var components: ComponentColor {
        ComponentColor(red: coreImageColor.red,
                       green: coreImageColor.green,
                       blue: coreImageColor.blue,
                       alpha: coreImageColor.alpha)
    }

    var isLight: Bool {
        let comp0 = (components.red) * 299
        let comp1 = (components.green) * 587
        let comp2 = (components.blue) * 114
        let brightness = (comp0 + comp1 + comp2) / 1000
        return brightness < 0.5 ? false : true
    }
}

struct ComponentColor {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

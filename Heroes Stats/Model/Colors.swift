//
//  Colors.swift
//  Heroes Stats
//
//  Created by Andrea Franchini on 07/06/2018.
//  Copyright © 2018 Andrea Franchini. All rights reserved.
//

import UIKit

extension UIColor {
    struct Accent {
        struct Purple {
            static let superlight = UIColor(red:0.82, green:0.64, blue:1.00, alpha:1.0)
            static let light = UIColor(red:0.64, green:0.38, blue:0.98, alpha:1.0)
            static let normal = UIColor(red:0.54, green:0.00, blue:1.00, alpha:1.0)
            static let dark = UIColor(red:0.44, green:0.00, blue:0.82, alpha:1.0)
            static let superdark = UIColor(red:0.24, green:0.00, blue:0.45, alpha:1.0)
        }
        struct Green {
            static let normal = UIColor(red:0.30, green:0.69, blue:0.31, alpha:1.0)
        }
        struct Red {
            static let normal = UIColor(red:0.96, green:0.26, blue:0.21, alpha:1.0)
        }
    }
}

class StatView: UIView {

    override func awakeFromNib() {
        layer.cornerRadius = 7
        layer.backgroundColor = UIColor.white.cgColor
        
    }
    
}

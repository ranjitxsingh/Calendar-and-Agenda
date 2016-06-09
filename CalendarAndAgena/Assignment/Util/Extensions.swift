//
//  Extensions.swift
//  Assignment
//
//  Created by Ranjit Singh on 07/06/16.
//  Copyright © 2016 Microsoft. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func msBlackColor() -> UIColor {
        return UIColor(red: 51.0 / 255.0, green: 65.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }
}

extension NSDate {
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        var isEqualTo = false
        if self.compare(dateToCompare) == .OrderedSame {
            isEqualTo = true
        }
        return isEqualTo
    }
}
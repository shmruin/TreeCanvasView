//
//  UITableViewCell+Conversion.swift
//  TreeCanvas
//
//  Created by ruin09 on 23/03/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /* Value conversion */
    func anyToString(_ value: Any?) -> String {
        if let nonNil = value, !(nonNil is NSNull) {
            return String(describing: nonNil)
        }
        print("String conversion error")
        return ""
    }
}

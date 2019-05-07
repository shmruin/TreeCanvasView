//
//  UIButton+Viewholder.swift
//  TreeCanvas
//
//  Created by ruin09 on 24/04/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

extension UIButton {
    struct Holder {
        static var _tappedIdx: Int = -1
        static var _popupView: UIView = UIView()
    }
    
    var tappedIdx: Int {
        get {
            return Holder._tappedIdx
        }
        set(newValue) {
            Holder._tappedIdx = newValue
        }
    }
    
    var popupView: UIView {
        get {
            return Holder._popupView
        }
        set(newValue) {
            Holder._popupView = newValue
        }
    }
}

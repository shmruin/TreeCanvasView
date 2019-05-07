//
//  TreeCanvasModPopupView.swift
//  TreeCanvas
//
//  Created by ruin09 on 06/04/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

class TreeCanvasModPopupView: UIView {
    private let xibName = String(describing: TreeCanvasModPopupView.self)

    @IBOutlet weak var modifiedTextInput: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}

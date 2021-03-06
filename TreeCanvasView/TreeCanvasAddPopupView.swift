//
//  TreeCanvasAddPopupView.swift
//  TreeCanvas
//
//  Created by ruin09 on 12/04/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

class TreeCanvasAddPopupView: UIView {
    private let xibName = String(describing: TreeCanvasAddPopupView.self)
    
    @IBOutlet weak var modifiedTextInput: UITextField!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var newNodeLocation: UISwitch!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
}

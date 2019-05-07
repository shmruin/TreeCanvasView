//
//  TreeCanvasView+Style.swift
//  TreeCanvas
//
//  Created by ruin09 on 25/04/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

extension TreeCanvasView {
    
    // Seperate rows by
    struct layerSeprator {
        private(set) var seperatorType: UInt8
        private(set) var fontSizeStyle = [String:Double]()
        private(set) var indentStyle = [String:Double]()
        
        init() {
            self.seperatorType = LayerSperatorType.fontSize.rawValue
            self.fontSizeStyle = ["headLevel":12.0, "diffLevel":2.0, "limitLevel":2.0]
            self.indentStyle = ["headLevel":0.0, "diffLevel":2.0, "limitLevel":10.0]
        }
        
        mutating func setSeperatorType(_ seperatorType: LayerSperatorType) {
            self.seperatorType = self.seperatorType | seperatorType.rawValue
        }
        
        mutating func setFontSize(_ fontSizeStyle: [String:Double]) {
            self.fontSizeStyle = fontSizeStyle
        }
        
        mutating func setIndent(_ indentStyle: [String:Double]) {
            self.indentStyle = indentStyle
        }
    }
    
    public func setLayerSeperatorType(_ layerSeperatorType: LayerSperatorType, _ headLevel: Double, _ diffLevel: Double, _ limitLevel: Double) {
        layerSeperatorManager.setSeperatorType(layerSeperatorType)
        if layerSeperatorType == .fontSize {
            layerSeperatorManager.setFontSize(["headLevel": headLevel, "diffLevel": diffLevel, "limitLevel": limitLevel])
        } else if layerSeperatorType == .indent {
            layerSeperatorManager.setIndent(["headLevel": headLevel, "diffLevel": diffLevel, "limitLevel": limitLevel])
        }
    }
    
    func applySeperators(_ cell: TreeCanvasDefaultCell, _ at: Int) {
        if layerSeperatorManager.seperatorType & LayerSperatorType.fontSize.rawValue != 0 {
            var ft = layerSeperatorManager.fontSizeStyle["headLevel"]! - layerSeperatorManager.fontSizeStyle["diffLevel"]! * Double(at - 1)
            if ft < layerSeperatorManager.fontSizeStyle["limitLevel"]! {
                ft = layerSeperatorManager.fontSizeStyle["limitLevel"]!
            }
            cell.treeNodeLabel.font = UIFont.systemFont(ofSize: CGFloat(ft))
        }
        if layerSeperatorManager.seperatorType & LayerSperatorType.indent.rawValue != 0 {
            var it = layerSeperatorManager.indentStyle["headLevel"]! + layerSeperatorManager.indentStyle["diffLevel"]! * Double(at - 1)
            if it > layerSeperatorManager.indentStyle["limitLevel"]! {
                it = layerSeperatorManager.indentStyle["limitLevel"]!
            }
            cell.indentationLevel = Int(it)
        }
    }
    
    func highlightTheLayer(_ layer: Int, _ isOn: Bool) {
        for (idx, node) in listOrderedTree.enumerated() {
            if node.layer == layer {
                let cell = cellForRow(at: IndexPath(row: idx, section: 0))
                if isOn {
                    cell?.contentView.backgroundColor = UIColor(hexString: "7F0BEE0B")
                } else {
                    cell?.contentView.backgroundColor = UIColor(hexString: "FFFFFF")
                }
            }
        }
    }
}

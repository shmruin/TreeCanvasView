//
//  TreeCanvasNode.swift
//  TreeCanvas
//
//  Created by ruin09 on 16/03/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import Foundation

/*
    A tree structure for data that will be stored through table view
 */

public final class TreeCanvasNode {
    
    let id: Int
    private(set) var layer: Int
    private(set) var valueType: Any.Type
    private(set) var value: Any
    private(set) var shown: Bool
    
    private(set) weak var parent: TreeCanvasNode?
    private(set) var children: [TreeCanvasNode] = []
    
    init(id: Int, layer: Int, valueType: Any.Type, value: Any, registerNode: (TreeCanvasNode) -> ()) {
        self.id = id
        self.layer = layer
        self.valueType = valueType
        self.value = value
        self.shown = true
        
        registerNode(self)
    }
    
    func changeValue(_ value: Any) {
        self.value = value
    }
    
    func changeLayer(_ layer: Int) {
        self.layer = layer
    }
    
    func unlinkChildren() {
        children.forEach { (child) in
            child.unlinkParent()
        }
        self.children = []
    }
    
    func unlinkParent() {
        self.parent = nil
    }
    
    func addChild(_ child: TreeCanvasNode) {
        children.append(child)
        child.parent = self
    }
    
    func addChildAt(_ child: TreeCanvasNode, _ at: Int) {
        children.insert(child, at: at)
        child.parent = self
    }
    
    func nthChild(_ child: TreeCanvasNode) throws -> Int {
        for (idx, myChild) in children.enumerated() {
            if myChild.id == child.id {
                return idx
            }
        }
        throw TreeCanvasError.thatChildNotExist
    }
    
    func expandChildren() {
        children.forEach { (child) in
            child.shown = true
        }
    }
    
    func collapseChildren() {
        children.forEach { (child) in
            child.shown = false
            child.collapseChildren()
        }
    }
}

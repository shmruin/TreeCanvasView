//
//  TreeCanvasView.swift
//  TreeCanvas
//
//  Created by ruin09 on 15/03/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

public class TreeCanvasView: UITableView {
    
    // Seperator style manager
    var layerSeperatorManager: layerSeprator = layerSeprator()
    
    // Root Tree ID as zero
    var TREE_ID_COUNTER = 0
    
    // Default cell id
    let cellId = "TreeCanvasDefaultCell"
    
    // Cell Height
    var treeCanvasCellHeight = 40.0
    
    var treeHashMap = [Int:TreeCanvasNode]() // Registered TreeCanvasNode as [ID : Node]
    var listOrderedTree = [TreeCanvasNode]() // Shown treeCanvasNodes ordered same as the table order
    
    var initCollpaseIds = [Int]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        // Make Tree Root Node
        _ = TreeCanvasNode(id: self.TREE_ID_COUNTER, layer: 0, valueType: String.self, value: "ROOT", registerNode: registerTreeHashMap)
        
        self.allowsSelection = true
        self.isUserInteractionEnabled = true
        self.register(TreeCanvasDefaultCell.self, forCellReuseIdentifier: cellId)
        self.dataSource = self
        self.delegate = self
        self.separatorStyle = .none
        
        // Apply Gesture Recognizer
        setupTapToCollapseNExpandDoubleTapToModifyRow()
        setupLongPressToMoveRow()
    }
}

// TreeCanvasView Delegate
extension TreeCanvasView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listOrderedTree[indexPath.row].shown == true {
            return CGFloat(treeCanvasCellHeight)
        } else {
            return 0    // hide
        }
    }
    
    // Row leading append action
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let appendSiblingAction = UIContextualAction(style: .normal, title:  "+Sibling", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.addTreeCanvasNode(indexPath.row, .Sibling)
            success(true)
        })
        appendSiblingAction.backgroundColor = UIColor(hexString: "0088FF")
        
        let appendChildAction = UIContextualAction(style: .normal, title:  "+Child", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.addTreeCanvasNode(indexPath.row, .Child)
            success(true)
        })
        appendChildAction.backgroundColor = UIColor(hexString: "0000FF")
        
        return UISwipeActionsConfiguration(actions: [appendSiblingAction, appendChildAction])
    }
    
    // Row trailing Delete action
    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.deleteTreeCanvasNode(indexPath.row)
            success(true)
        })
        deleteAction.backgroundColor = UIColor(hexString: "FF0000")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// TreeCanvasView Datasource
extension TreeCanvasView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOrderedTree.count
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TreeCanvasDefaultCell
        cell.selectionStyle = .none
        cell.contentTreeNode = listOrderedTree[indexPath.row]
        applySeperators(cell, listOrderedTree[indexPath.row].layer)
        return cell
    }
}

//
//  TreeCanvasView+Logic.swift
//  TreeCanvas
//
//  Created by ruin09 on 25/04/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

extension TreeCanvasView {
    public func idToIdx(_ nodeId: Int) throws -> Int {
        let wannaNode = treeHashMap[nodeId]
        guard let idx = listOrderedTree.firstIndex(where: {$0.id == wannaNode?.id}) else { throw TreeCanvasError.nodeNotExist }
        
        return idx
    }
    
    public func registerTreeHashMap(_ node: TreeCanvasNode) {
        treeHashMap[node.id] = node
    }
    
    // Make talbe list from currnet tree nodes : Basic DFS for list with tree structure
    private func makeCurrentListOrderedTree() throws {
        var visited = Set<Int>()
        var stack = TreeStack<TreeCanvasNode>()
        var res = [TreeCanvasNode]()
        
        guard let rootNode = treeHashMap[0] else {
            throw TreeCanvasError.rootNotExist
        }
        
        stack.push(rootNode)
        visited.insert(0)
        
        outer: while let vertex = stack.peek(), vertex != nil {
            
            if vertex.children.count == 0 {
                stack.pop()
                continue
            }
            
            for child in vertex.children {
                // Not visited yet
                if !visited.contains(child.id) {
                    visited.insert(child.id)
                    res.append(child)
                    stack.push(child)
                    continue outer
                }
            }
            
            stack.pop()
        }
        
        print(res.map({ element in
            element.value
        }))
        
        listOrderedTree = res
    }
    
    // Add children to parent id : return generated key array
    public func addNodesToParent<T>(_ nodeDataArr: [T], _ parentId: Int) -> [Int] {
        var newKeys = [Int]()
        
        do {
            if !checkNodeExist(parentId) {
                throw TreeCanvasError.parentNodeNotExist
            }
            try Array(1...nodeDataArr.count).forEach { _ in
                TREE_ID_COUNTER += 1
                if !checkUniqueId(TREE_ID_COUNTER) {
                    throw TreeCanvasError.nodeIdAlreadyTaken
                }
                newKeys.append(TREE_ID_COUNTER)
            }
        } catch TreeCanvasError.parentNodeNotExist {
            print("parent id is not existed.")
        } catch TreeCanvasError.nodeIdAlreadyTaken {
            print("id for new node is already taken.")
        } catch {
            print("Unknown Error here.")
        }
        
        do {
            for (idx, newKey) in newKeys.enumerated() {
                let newNode = TreeCanvasNode(id: newKey, layer: treeHashMap[parentId]!.layer + 1,valueType: type(of: T.self), value: nodeDataArr[idx], registerNode: registerTreeHashMap)
                try addChildTreeCanvasNodeToParent(newNode, parentId)
            }
        } catch TreeCanvasError.parentNodeNotExist {
            print("parent for new node not exist.")
        } catch {
            print("Unknown Error here.")
        }
        
        do {
            try makeCurrentListOrderedTree()
        } catch TreeCanvasError.rootNotExist {
            print("Tree Root is not exist.")
        } catch {
            print("Unknown Error here.")
        }
        
        return newKeys
    }
    
    func expandOrCollapseChildren(_ tappedIdx: Int) {
        let tappedNode = listOrderedTree[tappedIdx]
        
        if tappedNode.children.count == 0 {
            print("No children for this node.")
            return
        }
        
        if tappedNode.children[0].shown == true { // To Collapse
            collapseANode(tappedIdx)
        } else { // To Expand
            expandANode(tappedIdx)
        }
    }
    
    func expandANode(_ tappedIdx: Int) {
        let tappedNode = listOrderedTree[tappedIdx]
        
        tappedNode.expandChildren()
        
        reloadTableWithAnimation(self)
    }
    
    func collapseANode(_ tappedIdx: Int) {
        let tappedNode = listOrderedTree[tappedIdx]
        
        tappedNode.collapseChildren()
        
        reloadTableWithAnimation(self)
    }
    
    func reorderChildrenWhenParentMove(_ movedIdx: Int, _ leftChildrenIdxs: [Int], _ swapedIdx: Int, _ swapedRowLeftChildrenIdxs: [Int]) {
        if movedIdx == swapedIdx {
            return
        }
        
        // calculate each slice arrays start idx and length (will make 4 slice arrays)
        let parseIdx1 = swapedIdx + swapedRowLeftChildrenIdxs.count + 1
        let parseIdx2 = movedIdx + leftChildrenIdxs.count + 1

        var sliceArrs: [[TreeCanvasNode]] = []
        var movedAndSwapedIdxs = [Int]()

        for var idx in 0..<listOrderedTree.count {
            if idx == movedIdx {
                let swappedArr = Array(listOrderedTree[idx...idx + leftChildrenIdxs.count]) //Swapped Arr
                idx += (leftChildrenIdxs.count + 1)
                movedAndSwapedIdxs.append(sliceArrs.count)
                sliceArrs.append(swappedArr)
            } else if idx == swapedIdx {
                let movedArr = Array(listOrderedTree[idx...idx + swapedRowLeftChildrenIdxs.count]) //Moved Arr
                idx += (swapedRowLeftChildrenIdxs.count + 1)
                movedAndSwapedIdxs.append(sliceArrs.count)
                sliceArrs.append(movedArr)
            } else if idx == 0 {
                var parseIdxCount = 0
                while idx + parseIdxCount + 1 < listOrderedTree.count &&
                    idx + parseIdxCount + 1 != movedIdx &&
                    idx + parseIdxCount + 1 != swapedIdx {
                        parseIdxCount += 1
                }
                let parseArr0 = Array(listOrderedTree[idx...idx + parseIdxCount])
                sliceArrs.append(parseArr0)
            } else if idx == parseIdx1 {
                var parseIdxCount = 0
                while idx + parseIdxCount + 1 < listOrderedTree.count &&
                    idx + parseIdxCount + 1 != movedIdx &&
                    idx + parseIdxCount + 1 != swapedIdx {
                        parseIdxCount += 1
                }
                let parseArr1 = Array(listOrderedTree[idx...idx + parseIdxCount])
                sliceArrs.append(parseArr1)
            } else if idx == parseIdx2 {
                var parseIdxCount = 0
                while idx + parseIdxCount + 1 < listOrderedTree.count &&
                    idx + parseIdxCount + 1 != movedIdx &&
                    idx + parseIdxCount + 1 != swapedIdx {
                        parseIdxCount += 1
                }
                let parseArr2 = Array(listOrderedTree[idx...idx + parseIdxCount])
                sliceArrs.append(parseArr2)
            }
        }
        
        // change the order of moved arr and swapped arr
        sliceArrs.swapAt(movedAndSwapedIdxs[0], movedAndSwapedIdxs[1])

        // Table UI is completely set after move
        listOrderedTree = sliceArrs.reduce([], { $0 + $1 })
        
        // Logical children reset as swapped
        swapChildrenNodesOf(movedIdx, swapedIdx)
        
        reloadTableWithAnimation(self)
    }
    
    func swapChildrenNodesOf(_ movedIdx: Int, _ swapedIdx: Int) {
        let movedParentNode = listOrderedTree[movedIdx]
        let swapedParentNode = listOrderedTree[swapedIdx]
        
        let movedParentLayer = movedParentNode.layer
        let swapedParentLayer = swapedParentNode.layer
        
        swapedParentNode.unlinkChildren()
        movedParentNode.unlinkChildren()
        
        var reqSetChildren = findExactChildrenUntilLargerLayer(movedParentLayer, movedIdx)
        
        reqSetChildren.forEach { (idx) in
            movedParentNode.addChild(listOrderedTree[idx])
        }
        
        reqSetChildren = findExactChildrenUntilLargerLayer(swapedParentLayer, swapedIdx)
        
        reqSetChildren.forEach { (idx) in
            swapedParentNode.addChild(listOrderedTree[idx])
        }
    }
    
    func changeTreeCanvasNodeValue(_ tappedIdx: Int) {
        // Popup to change value
        let window = UIApplication.shared.keyWindow!
        let defaultPopup = TreeCanvasModPopupView(frame: window.bounds)
        defaultPopup.btnConfirm.tappedIdx = tappedIdx
        defaultPopup.btnConfirm.popupView = defaultPopup
        defaultPopup.btnConfirm.addTarget(self, action: #selector(modifyConfirmed(_:)), for: .touchUpInside)
        defaultPopup.btnCancel.addTarget(self, action: #selector(modifyCanceled(_:)), for: .touchUpInside)
        window.addSubview(defaultPopup)
    }
    
    @objc func modifyConfirmed(_ sender: UIButton) {
        let defaultPopup = sender.popupView as! TreeCanvasModPopupView
        
        listOrderedTree[sender.tappedIdx].changeValue(defaultPopup.modifiedTextInput.text!)
        defaultPopup.removeFromSuperview()
        self.reloadData()
    }
    
    @objc func modifyCanceled(_ sender: UIButton) {
        let defaultPopup = sender.popupView as! TreeCanvasModPopupView
        defaultPopup.removeFromSuperview()
    }
    
    func deleteTreeCanvasNode(_ tappedIdx: Int) {
        let deletedNode = listOrderedTree[tappedIdx]
        
        // Remove from listOrderTree
        var removeIndexArr = findIdxsUntilLargerLayer(deletedNode.layer, tappedIdx)
        let removeIdArr = removeIndexArr.map { (idx) -> Int in listOrderedTree[idx].id }
        
        // Erase self and children
        removeIndexArr.insert(tappedIdx, at: 0)
        listOrderedTree.removeSubrange(removeIndexArr[0]...removeIndexArr.last!)
        
        // Remove on treeHashMap (As all children are cleared, ARC will deinit)
        treeHashMap.removeValue(forKey: deletedNode.id)
        removeIdArr.forEach { (id) in
            treeHashMap.removeValue(forKey: id)
        }
        
        reloadTableWithAnimation(self)
    }
    
    func addTreeCanvasNode(_ tappedIdx: Int, _ siblingOrChild: NodeFamilyType) {
        // Popup to add a node to table
        let window = UIApplication.shared.keyWindow!
        let defaultPopup = TreeCanvasAddPopupView(frame: window.bounds)
        defaultPopup.btnConfirm.tappedIdx = tappedIdx
        defaultPopup.btnConfirm.popupView = defaultPopup
        
        if siblingOrChild == .Sibling {
            defaultPopup.btnConfirm.addTarget(self, action: #selector(addingSiblingConfirmed(_:)), for: .touchUpInside)
        } else {
            defaultPopup.btnConfirm.addTarget(self, action: #selector(addingChildConfirmed(_:)), for: .touchUpInside)
        }
        
        defaultPopup.btnCancel.addTarget(self, action: #selector(addingCanceled(_:)), for: .touchUpInside)
        window.addSubview(defaultPopup)
    }
    
    @objc func addingSiblingConfirmed(_ sender: UIButton) {
        let defaultPopup = sender.popupView as! TreeCanvasAddPopupView
        
        let tappedNode = listOrderedTree[sender.tappedIdx]
        let nodeValue = defaultPopup.modifiedTextInput.text!
        let nodeUnderPosition = defaultPopup.newNodeLocation.isOn // True: Under, False: Above
        
        do {
            let tappedNodeIsNthChild = try tappedNode.parent!.nthChild(tappedNode)
            
            // operating on treeHashMap & listOrderedTree
            self.TREE_ID_COUNTER += 1
            let newNode = TreeCanvasNode(id: self.TREE_ID_COUNTER, layer: tappedNode.layer, valueType: type(of: nodeValue.self), value: nodeValue, registerNode: registerTreeHashMap)
            if nodeUnderPosition == true {
                try addChildTreeCanvasNodeToParent(newNode, tappedNode.parent!.id, tappedNodeIsNthChild + 1)
                let UnderSiblingPosition = findIdxUnderSameLayerInParent(tappedNode.layer, sender.tappedIdx)
                if UnderSiblingPosition == -1 {
                    listOrderedTree.append(newNode)
                } else {
                    listOrderedTree.insert(newNode, at: UnderSiblingPosition)
                }
            } else {
                try addChildTreeCanvasNodeToParent(newNode, tappedNode.parent!.id, tappedNodeIsNthChild)
                listOrderedTree.insert(newNode, at: sender.tappedIdx)
            }
        } catch TreeCanvasError.parentNodeNotExist {
            print("parent for new node not exist.")
        } catch TreeCanvasError.thatChildNotExist {
            print("tappedNode is not a child of parent.")
        } catch {
            print("Unknown Error here.")
        }
        
        defaultPopup.removeFromSuperview()
        reloadTableWithAnimation(self)
    }
    
    @objc func addingChildConfirmed(_ sender: UIButton) {
        let defaultPopup = sender.popupView as! TreeCanvasAddPopupView
        
        let tappedNode = listOrderedTree[sender.tappedIdx]
        let nodeValue = defaultPopup.modifiedTextInput.text!
        let nodeUnderPosition = defaultPopup.newNodeLocation.isOn // True: Under, False: Above
        
        do {
            // operating on treeHashMap & listOrderedTree
            self.TREE_ID_COUNTER += 1
            let newNode = TreeCanvasNode(id: self.TREE_ID_COUNTER, layer: tappedNode.layer + 1, valueType: type(of: nodeValue.self), value: nodeValue, registerNode: registerTreeHashMap)
            if nodeUnderPosition == true {
                try addChildTreeCanvasNodeToParent(newNode, tappedNode.id, tappedNode.children.count)
                listOrderedTree.insert(newNode, at: sender.tappedIdx + tappedNode.children.count)
            } else {
                try addChildTreeCanvasNodeToParent(newNode, tappedNode.id, 0)
                listOrderedTree.insert(newNode, at: sender.tappedIdx + 1)
            }
        } catch TreeCanvasError.parentNodeNotExist {
            print("parent for new node not exist.")
        } catch {
            print("Unknown Error here.")
        }
        
        defaultPopup.removeFromSuperview()
        reloadTableWithAnimation(self)
    }
    
    @objc func addingCanceled(_ sender: UIButton) {
        let defaultPopup = sender.popupView as! TreeCanvasAddPopupView
        defaultPopup.removeFromSuperview()
    }
    
    public func findNodeById(_ id: Int) throws -> TreeCanvasNode {
        if treeHashMap[id] == nil {
            throw TreeCanvasError.nodeNotExist
        }
        
        return treeHashMap[id]!
    }
    
    private func addChildTreeCanvasNodeToParent(_ child: TreeCanvasNode, _ parentId: Int, _ at: Int = -1) throws {
        if !checkNodeExist(parentId) {
            throw TreeCanvasError.parentNodeNotExist
        }
        
        if at == -1 {
            treeHashMap[parentId]?.addChild(child)
        } else {
            treeHashMap[parentId]?.addChildAt(child, at)
        }
    }
    
    func findExactChildrenUntilLargerLayer(_ fromLayer: Int, _ fromIdx: Int) -> [Int] {
        var resArr = [Int]()
        for (idx, val) in listOrderedTree[fromIdx + 1..<listOrderedTree.count].enumerated() {
            if val.layer <= fromLayer {
                break
            }
            
            if val.layer == fromLayer + 1 {
                resArr.append(fromIdx + 1 + idx)
            }
        }
        
        return resArr
    }
    
    func findIdxsUntilLargerLayer(_ fromLayer: Int, _ fromIdx: Int) -> [Int] {
        var resArr = [Int]()
        for (idx, val) in listOrderedTree[fromIdx + 1..<listOrderedTree.count].enumerated() {
            if val.layer <= fromLayer {
                break
            }
            
            resArr.append(fromIdx + 1 + idx)
        }
        
        return resArr
    }
    
    func findIdxUnderSameLayerInParent(_ fromLayer: Int, _ fromIdx: Int) -> Int {
        for (idx, val) in listOrderedTree[fromIdx + 1..<listOrderedTree.count].enumerated() {
            if val.layer <= fromLayer {
                return fromIdx + idx + 1
            }
        }
        
        return -1
    }
    
    // Print Current Tree nodes with structure on console (debugging)
    public func printCurrentTreeCanvasView(_ depth: Int = -1) {
        let space = " "
        let seperator = "⌞"
        
        print("!!! ID 0, Layer 0 is a Root. It is not included in TreeCanvasView but in registered TreeCanvasNode. !!!")
        
        listOrderedTree.forEach { (node) in
            if depth == -1 || node.layer <= depth {
                if node.layer != 1 {
                    for _ in 0..<node.layer {
                        print(space, terminator:"")
                    }
                    print(seperator, terminator:"")
                }
                
                print("ID: " + String(node.id), terminator: ", ")
                print("Layer: " + String(node.layer), terminator: ", ")
                print("IsShow: " + String(node.shown), terminator: ", ")
                print("Value: " + String(describing: node.value))
            }
        }
    }
    
    public func printCurrentRegisteredTreeCanvasNode() {
        print("TreeCanvasNode IDs : ", terminator:"")
        treeHashMap.forEach { (id, node) in
            print(id, separator: ", ", terminator:" ")
        }
        print()
    }
    
    /* Utils */
    
    private func checkUniqueId(_ id: Int) -> Bool {
        return treeHashMap[id] == nil
    }
    
    private func checkNodeExist(_ id: Int) -> Bool {
        return treeHashMap[id] != nil ? true : false
    }
    
    func reloadTableWithAnimation(_ target: UITableView, _ completeCallback: ((Bool)->Void)? = nil) {
        UIView.transition(with: target, duration: 0.3, options: .transitionCrossDissolve, animations: {self.reloadData()}, completion: completeCallback)
    }
}

//
//  TreeCanvasGestureController.swift
//  TreeCanvas
//
//  Created by ruin09 on 28/03/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

/*
 Mode SHOW & EDIT
 - Tap : Collapse and expand a row
 - Long press over 0.5 : Move a row and its children to
 - Slide foward: Show menu to remove a row
 - Slide back : Show menu to add a row (Sibling, Child) + Popup
 - Double tap : Modify a row + Popup
 */

extension TreeCanvasView {
    
    func setupTapToCollapseNExpandDoubleTapToModifyRow() {
        let tapToCollapseNExpandGestrue: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToCollapseNExpand))
        tapToCollapseNExpandGestrue.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapToCollapseNExpandGestrue)
        
        let doubleTapToModifyRowGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTapToModifyRow))
        doubleTapToModifyRowGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapToModifyRowGesture)
        
        tapToCollapseNExpandGestrue.require(toFail: doubleTapToModifyRowGesture)
    }
    
    @objc func handleTapToCollapseNExpand(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let touchPoint = sender.location(in: self)
            if let indexPath = self.indexPathForRow(at: touchPoint) {
                // Expand or collapse the row
                self.expandOrCollapseChildren(indexPath.row)
            }
        }
    }
    
    @objc func handleDoubleTapToModifyRow(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let touchPoint = sender.location(in: self)
            if let indexPath = self.indexPathForRow(at: touchPoint) {
                // Move rows to somewhere else
                self.changeTreeCanvasNodeValue(indexPath.row)
            }
        }
    }
    
    func setupLongPressToMoveRow() {
        let longPressToModeChangeOrMoveRowGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressToMoveRow))
        longPressToModeChangeOrMoveRowGesture.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPressToModeChangeOrMoveRowGesture)
    }
    
    // Refer to "fairbanksdan/DragNDrop-Final.git"
    @objc func handleLongPressToMoveRow(_ sender: UILongPressGestureRecognizer) {
        let longPress = sender
        let state = longPress.state
        let locationInView = longPress.location(in: self)
        let indexPath = self.indexPathForRow(at: locationInView)
        
        struct My {
            static var cellSnapshot: UIView? = nil
            static var cellIsAnimating: Bool = false
            static var cellNeedToShow: Bool = false
            static var reorderChildrenIdxs = [Int]()
            static var swapedRowReorderChildrenIdxs = [Int]()
        }
        struct Path {
            static var initialIndexPath: IndexPath? = nil
            static var swapedIndexPath: IndexPath? = nil
        }
        
        switch state {
        case .began:
            if indexPath != nil {
                // Collapse rows by selected layer
                My.reorderChildrenIdxs = self.findIdxsUntilLargerLayer(self.listOrderedTree[indexPath!.row].layer, indexPath!.row)
                
                Path.initialIndexPath = indexPath
                
                self.highlightTheLayer(self.listOrderedTree[Path.initialIndexPath!.row].layer, true)
                let cell = self.cellForRow(at: indexPath!) as! TreeCanvasDefaultCell
                My.cellSnapshot = self.snapshotOfCell(cell)
                
                var center = cell.center
                My.cellSnapshot!.center = center
                My.cellSnapshot!.alpha = 0.0
                self.addSubview(My.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center.y = locationInView.y
                    My.cellIsAnimating = true
                    My.cellSnapshot!.center = center
                    My.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    My.cellSnapshot!.alpha = 0.98
                    cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell.alpha = 1
                            })
                        } else {
                            cell.isHidden = true
                        }
                    }
                })
            }
        case .changed:
            if My.cellSnapshot != nil {
                var center = My.cellSnapshot!.center
                center.y = locationInView.y
                My.cellSnapshot!.center = center
                
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    // Moving Rows should be happened between same layer
                    let originNode = self.listOrderedTree[Path.initialIndexPath!.row]
                    let thisNode = self.listOrderedTree[indexPath!.row]
                    
                    if thisNode.layer == originNode.layer {
                        Path.swapedIndexPath = indexPath
                        
                        My.swapedRowReorderChildrenIdxs = self.findIdxsUntilLargerLayer(self.listOrderedTree[Path.swapedIndexPath!.row].layer, Path.swapedIndexPath!.row)
                    }
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = self.cellForRow(at: Path.initialIndexPath!) as! TreeCanvasDefaultCell
                if My.cellIsAnimating {
                    My.cellNeedToShow = true
                } else {
                    cell.isHidden = false
                    cell.alpha = 0.0
                }
                
                self.highlightTheLayer(self.listOrderedTree[Path.initialIndexPath!.row].layer, false)
                
                if Path.swapedIndexPath != nil {
                    self.reorderChildrenWhenParentMove(Path.initialIndexPath!.row, My.reorderChildrenIdxs, Path.swapedIndexPath!.row, My.swapedRowReorderChildrenIdxs)
                    
                    Path.swapedIndexPath = nil
                    My.swapedRowReorderChildrenIdxs = [Int]()
                }
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    My.cellSnapshot!.center = cell.center
                    My.cellSnapshot!.transform = CGAffineTransform.identity
                    My.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0
                }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        My.cellSnapshot!.removeFromSuperview()
                        My.cellSnapshot = nil
                    }
                })
            }
        }
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
}

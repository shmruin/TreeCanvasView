//
//  TreeCanvasDefaultCell.swift
//  TreeCanvas
//
//  Created by ruin09 on 23/03/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import UIKit

class TreeCanvasDefaultCell: UITableViewCell {
    
    var contentTreeNode: TreeCanvasNode? {
        didSet {
            // Something to set contentTreeNode
            treeNodeLabel.text = anyToString(contentTreeNode?.value)
        }
    }
    
    // Cell components setting
    public var treeNodeLabel: UILabel = {
        let tlbl = UILabel()
        tlbl.translatesAutoresizingMaskIntoConstraints = false
        tlbl.textColor = .black
        tlbl.font = UIFont.systemFont(ofSize: 16)
        tlbl.textAlignment = .left
        return tlbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(treeNodeLabel)
        
        // Cell constraints setting
        let marginGuide = self.contentView.layoutMarginsGuide
        
        treeNodeLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        treeNodeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        treeNodeLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        treeNodeLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutMargins.left = layoutMargins.left + CGFloat(indentationLevel) * indentationWidth
    }
}

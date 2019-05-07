//
//  TreeCanvasView+Predefine.swift
//  TreeCanvas
//
//  Created by ruin09 on 25/04/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

enum TreeCanvasError : Error {
    case nodeIdAlreadyTaken
    case parentNodeNotExist
    case nodeNotExist
    case rootNotExist
    case thatChildNotExist
}

public enum LayerSperatorType: UInt8 {
    case fontSize = 0b00000001
    case indent = 0b00000010
}

public enum NodeFamilyType {
    case Sibling
    case Child
}

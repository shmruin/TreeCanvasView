//
//  TreeStack.swift
//  TreeCanvas
//
//  Created by ruin09 on 18/03/2019.
//  Copyright © 2019 ruin09. All rights reserved.
//

import Foundation

struct TreeStack<T> {
    private var items: [T] = []
    
    func peek() -> T? {
        guard let topElement = items.first else { return nil }
        return topElement
    }
    
    func count() -> Int {
        return items.count
    }
    
    mutating func pop() {
        items.removeFirst()
    }
    
    mutating func push(_ element: T) {
        items.insert(element, at: 0)
    }
}

//
//  Direction.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit

enum Direction {
    case left
    case right
}

// MARK: SKNode + Direction
extension SKNode {
    func updateNodeDirection(direction: Direction) {
        var multiplierForDirection: CGFloat
        switch direction {
        case .left:
            multiplierForDirection = -1
        case .right:
            multiplierForDirection = 1
        }
          
        xScale = abs(xScale) * multiplierForDirection
    }
}

//
//  FloatingNode.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 13.10.2022.
//

import SpriteKit

final class FloatingNode: SKSpriteNode {
    
    // MARK: Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        animate()
    }
}

// MARK: Private API
private extension FloatingNode {
    func animate() {
        
        let startingPointY = position.y
        
        // Calculation of animation properties based on node size
        // to achieve seemingly "random" animation
        let offset = size.height * 0.2
        let duration = size.height * 0.02
        
        run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.moveTo(y: startingPointY - offset, duration: duration),
                    SKAction.moveTo(y: startingPointY + offset, duration: duration)
                ]))
        )
    }
}

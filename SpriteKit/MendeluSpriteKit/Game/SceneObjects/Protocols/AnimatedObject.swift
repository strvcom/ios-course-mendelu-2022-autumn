//
//  AnimatedObject.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit

protocol AnimatedObject {
    var animations: [String: SKAction] { get }
    
    func playAnimation(key: String)
}

// MARK: AnimatedObject + SKNode
extension AnimatedObject where Self: SKNode {
    func playAnimation(key: String) {
        guard
            action(forKey: key) == nil,
            let action = animations[key]
        else {
            return
        }
        
        removeAllActions()
        
        run(
            action,
            withKey: key
        )
    }
}

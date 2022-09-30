//
//  GameObject.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import UIKit
import SpriteKit

protocol GameObject {
    func setup(gameScene: LevelScene)
    
    func update(_ currentTime: TimeInterval)
    
    func keyboardDown(presses: Set<UIPress>)
    
    func keyboardUp(presses: Set<UIPress>)
}

// MARK: Default Implementation
extension GameObject {
    func update(_ currentTime: TimeInterval) {}
    
    func keyboardDown(presses: Set<UIPress>) {}
    
    func keyboardUp(presses: Set<UIPress>) {}
}

// MARK: GameObject + SKNode
extension GameObject where Self: SKNode {
    var gameScene: LevelScene? {
        scene as? LevelScene
    }
}

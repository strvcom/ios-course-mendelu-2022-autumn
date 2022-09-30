//
//  GameObject.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import UIKit
import SpriteKit

protocol SceneObject {
    func setup(scene: LevelScene)
    
    func update(_ currentTime: TimeInterval)
    
    func keyboardDown(presses: Set<UIPress>)
    
    func keyboardUp(presses: Set<UIPress>)
    
    func handleContact(_ contact: SKPhysicsContact)
}

// MARK: Default Implementation
extension SceneObject {
    func setup(scene: LevelScene) {}
    
    func update(_ currentTime: TimeInterval) {}
    
    func keyboardDown(presses: Set<UIPress>) {}
    
    func keyboardUp(presses: Set<UIPress>) {}
    
    func handleContact(_ contact: SKPhysicsContact) {}
}

// MARK: SceneObject + SKNode
extension SceneObject where Self: SKNode {
    var levelScene: LevelScene? {
        scene as? LevelScene
    }
}

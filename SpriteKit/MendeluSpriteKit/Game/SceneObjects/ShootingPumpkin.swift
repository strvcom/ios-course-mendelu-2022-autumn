//
//  ShootingPumpkin.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import SpriteKit

final class ShootingPumpkin: SKSpriteNode {
    // MARK: Properties
    private let eatingFrames = SKTextureAtlas(named: Assets.Atlas.pumpkinEating).textures
    
    private(set) var animations = [String : SKAction]()
}

// MARK: SceneObject
extension ShootingPumpkin: SceneObject {
    func setup(scene: LevelScene) {
        setupActions()
        
        setupPumpkin()
    }
    
    func update(_ currentTime: TimeInterval) {
        playAnimation(key: Animations.eating.rawValue)
    }
}

// MARK: AnimatedObject
extension ShootingPumpkin: AnimatedObject {}

// MARK: Animations
private extension ShootingPumpkin {
    enum Animations: String {
        case eating
    }
}

// MARK: Private API
private extension ShootingPumpkin {
    func setupPumpkin() {
        zPosition = Layer.shootingPumpkin
    }
    
    func setupActions() {
        animations[Animations.eating.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: eatingFrames,
                timePerFrame: 0.25,
                resize: false,
                restore: true
            )
        )
    }
}

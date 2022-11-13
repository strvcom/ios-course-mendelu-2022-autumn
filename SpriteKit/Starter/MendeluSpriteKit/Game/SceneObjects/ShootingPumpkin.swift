//
//  ShootingPumpkin.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import SpriteKit

final class ShootingPumpkin: SKSpriteNode {
    // MARK: Properties
}

// MARK: SceneObject
extension ShootingPumpkin: SceneObject {
    func setup(scene: LevelScene) {
        // TODO: Implement setup
        
        setupActions()
    }
    
    func update(_ currentTime: TimeInterval) {
        // TODO: Implement update
    }
    
    func handleContactStart(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == ObjectNames.projectile {
            handleProjectileHit(
                with: contact.bodyB,
                projectile: contact.bodyA
            )
        } else if contact.bodyB.node?.name == ObjectNames.projectile {
            handleProjectileHit(
                with: contact.bodyA,
                projectile: contact.bodyB
            )
        }
    }
}

// MARK: Animations
private extension ShootingPumpkin {
    enum Animations: String {
        case eating
    }
}

// MARK: Private API
private extension ShootingPumpkin {
    func setupActions() {
        // TODO: Implement setupActions
    }
    
    func shoot() {
        // TODO: Implement shoot
    }
    
    func handleProjectileHit(
        with body: SKPhysicsBody,
        projectile: SKPhysicsBody
    ) {
        // TODO: Implement handleProjectileHit
    }
}

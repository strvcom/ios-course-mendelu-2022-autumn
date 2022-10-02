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
        let eatingTimePerFrame: TimeInterval = 0.25
        
        let waitDuration = (Double(eatingFrames.count) / 2) * eatingTimePerFrame
        
        animations[Animations.eating.rawValue] = SKAction.repeatForever(
            SKAction.group([
                SKAction.sequence([
                    SKAction.wait(forDuration: waitDuration),
                    SKAction.run { [weak self] in
                        self?.shoot()
                    },
                    SKAction.wait(forDuration: waitDuration)
                ]),
                SKAction.animate(
                    with: eatingFrames,
                    timePerFrame: 0.25,
                    resize: false,
                    restore: true
                )
            ])
        )
    }
    
    func shoot() {
        let projectile = SKSpriteNode(texture: SKTexture(imageNamed: Assets.Image.projectile))
        projectile.name = ObjectNames.projectile
        projectile.zPosition = 30
        projectile.physicsBody = SKPhysicsBody(rectangleOf: projectile.size)
        projectile.physicsBody?.affectedByGravity = false
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        projectile.physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.projectile
        projectile.position = CGPoint(
            x: position.x,
            y: position.y - 20
        )
        
        levelScene?.addChild(projectile)
        
        projectile.physicsBody?.applyImpulse(
            CGVector(
                dx: -2,
                dy: 0
            )
        )
    }
    
    func handleProjectileHit(
        with body: SKPhysicsBody,
        projectile: SKPhysicsBody
    ) {
        projectile.node?.removeFromParent()
        
        print("Projectile collision with \(body)")
    }
}

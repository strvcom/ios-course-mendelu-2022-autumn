//
//  Zombie.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit

final class Zombie: SKSpriteNode {
    // MARK: Properties
    private var idleFrames = [SKTexture]()
    private var walkingFrames = [SKTexture]()
    private var attackFrames = [SKTexture]()
    
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }
            
            updateNodeDirection(direction: direction)
        }
    }
    
    private var animationState: AnimationState = .idle {
        didSet {
            guard oldValue != animationState else {
                return
            }
            
            updateStateAnimation()
        }
    }
    
    private var velocity: CGFloat {
        let distance = playerPosition.distance(to: position)
        
        guard distance < 200 else {
            return 0
        }
        
        return playerPosition.x > position.x
            ? 1
            : -1
    }
    
    private var playerPosition: CGPoint {
        levelScene?.player.position ?? .zero
    }
    
    private var isWalking: Bool {
        velocity != 0
    }
}

// MARK: PlayerState
private extension Zombie {
    enum AnimationState {
        case walking
        case idle
    }
}

// MARK: GameObject
extension Zombie: SceneObject {
    func setup(scene: LevelScene) {
        idleFrames = SKTextureAtlas(named: Assets.Atlas.zombieIdle).textures
        walkingFrames = SKTextureAtlas(named: Assets.Atlas.zombieWalk).textures
        
        updateStateAnimation()
        
        zPosition = Layer.player
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.zombie
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
    }
    
    func update(_ currentTime: TimeInterval) {
        guard
            let body = levelScene?.physicsWorld.body(
                alongRayStart: position,
                end: playerPosition
            ),
            body.categoryBitMask == Physics.CategoryBitMask.player
        else {
            return
        }
        
        updateDirection()
        
        updatePosition()
        
        updateState()
    }
    
    func handleContactStart(_ contact: SKPhysicsContact) {
        if contact.bodyA == self {
            handleContactWith(
                body: contact.bodyB,
                contact: contact
            )
        } else if contact.bodyB == self {
            handleContactWith(
                body: contact.bodyA,
                contact: contact
            )
        }
    }
}

// MARK: Private API
private extension Zombie {
    func updateState() {
        animationState = isWalking
            ? .walking
            : .idle
    }
    
    func updateDirection() {
        direction = playerPosition.x > position.x
            ? .right
            : .left
    }
    
    func updatePosition() {
        let moveBy = size.width * 0.07 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
    
    func updateStateAnimation() {
        removeAllActions()
        
        switch animationState {
        case .idle:
            run(
                SKAction.repeatForever(
                    SKAction.animate(
                        with: idleFrames,
                        timePerFrame: 0.2,
                        resize: false,
                        restore: true
                    )
                )
            )
        case .walking:
            run(
                SKAction.repeatForever(
                    SKAction.animate(
                        with: walkingFrames,
                        timePerFrame: 0.2,
                        resize: false,
                        restore: true
                    )
                )
            )
        }
    }
    
    func handleContactWith(
        body: SKPhysicsBody,
        contact: SKPhysicsContact
    ) {
        switch body {
        case _ as Player:
            print("Pain player hit")
        default:
            break
        }
    }
}

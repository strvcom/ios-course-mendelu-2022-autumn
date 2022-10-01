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
    private var direction: Direction = .right
    private var animationState: AnimationState = .walking {
        didSet {
            guard oldValue != animationState else {
                return
            }
            
            updateStateAnimation()
        }
    }
}

// MARK: PlayerState
private extension Zombie {
    enum AnimationState {
        case walking
        case idle
    }
}

// MARK: Direction
extension Zombie {
    enum Direction {
        case left
        case right
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
        let playerPosition = levelScene?.player.position ?? .zero
        
        guard
            let body = levelScene?.physicsWorld.body(
                alongRayStart: position,
                end: playerPosition
            ),
            body.categoryBitMask == Physics.CategoryBitMask.player
        else {
            return
        }
        
        updateSpriteDirection(
            newDirection: playerPosition.x > position.x
                ? .right
                : .left
        )
        
        let distance = playerPosition.distance(to: position)
        
        print("Pain", distance)
        
        
        updateState()
    }
}

// MARK: Private API
private extension Zombie {
    func updateState() {
        
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
    
    func updatePosition() {
        
    }
    
    func updateSpriteDirection() {
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

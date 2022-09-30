//
//  Player.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

final class Player: SKSpriteNode {
    // MARK: Properties
    private var idleFrames = [SKTexture]()
    private var walkingFrames = [SKTexture]()
    
    private var velocity: CGFloat {
        levelScene?.joystick.velocity ?? 0
    }
    
    private(set) var state: PlayerState = .idle
    private(set) var jumped = false
    private(set) var direction: Direction = .right
}

// MARK: PlayerState
extension Player {
    enum PlayerState {
        case walking
        case idle
    }
}

// MARK: Direction
extension Player {
    enum Direction {
        case left
        case right
    }
}

// MARK: GameObject
extension Player: SceneObject {
    func setup(scene: LevelScene) {
        idleFrames = SKTextureAtlas(named: Assets.Atlas.playerIdle).textures
        walkingFrames = SKTextureAtlas(named: Assets.Atlas.playerWalk).textures
        
        updateStateAnimation()
        
        setupPlayer()
    }
    
    func update(_ currentTime: TimeInterval) {
        updateDirection()
        
        updateState()
        
        updatePosition()
    }
    
    func handleContact(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == self {
            handleContactWith(
                body: contact.bodyB,
                contact: contact
            )
        } else if contact.bodyB.node == self {
            handleContactWith(
                body: contact.bodyA,
                contact: contact
            )
        }
    }
}

// MARK: Public API
extension Player {
    func jump() {
        guard !jumped else {
            return
        }
        
        jumped = true
        
        physicsBody?.applyImpulse(
            CGVector(
                dx: 0,
                dy: size.height * 0.7
            )
        )
    }
}

// MARK: Private API
private extension Player {
    func setupPlayer() {
        zPosition = Layer.player
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.player
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.contactTestBitMask = Physics.CategoryBitMask.groundTile
    }
    
    func updateState() {
        let newState: PlayerState = velocity == 0
            ? .idle
            : .walking
        
        guard newState != state else {
            return
        }
        
        state = newState
        
        updateStateAnimation()
    }
    
    func updateStateAnimation() {
        removeAllActions()
        
        switch state {
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
    
    func updateDirection() {
        var newDirection = direction
        
        if velocity > 0 {
            newDirection = .right
        } else if velocity < 0 {
            newDirection = .left
        }
        
        guard newDirection != direction else {
            return
        }
        
        direction = newDirection
        
        updateSpriteDirection()
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
    
    func updatePosition() {
        let moveBy = size.width * 0.3 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
    
    func handleContactWith(
        body: SKPhysicsBody,
        contact: SKPhysicsContact
    ) {
        switch body.node?.name {
        case ObjectNames.tile:
            guard contact.contactNormal.dy > 0 else {
                return
            }
            
            jumped = false
        default:
            break
        }
    }
}

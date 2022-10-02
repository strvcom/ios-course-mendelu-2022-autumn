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
    private var deathFrames = [SKTexture]()
    private var isDead = false
    
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }
            
            updateNodeDirection(direction: direction)
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
    
    private(set) var animations = [String: SKAction]()
}

// MARK: GameObject
extension Zombie: SceneObject {
    func setup(scene: LevelScene) {
        idleFrames = SKTextureAtlas(named: Assets.Atlas.zombieIdle).textures
        
        walkingFrames = SKTextureAtlas(named: Assets.Atlas.zombieWalk).textures
        
        deathFrames = SKTextureAtlas(named: Assets.Atlas.zombieDeath).textures
        
        animations[Animations.idle.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: idleFrames,
                timePerFrame: 0.2,
                resize: false,
                restore: true
            )
        )
        
        animations[Animations.walking.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: walkingFrames,
                timePerFrame: 0.2,
                resize: false,
                restore: true
            )
        )
        
        let deathTimePerFrame: TimeInterval = 0.3
        
        animations[Animations.death.rawValue] = SKAction.group([
            SKAction.run { [weak self] in
                self?.physicsBody = nil
            },
            SKAction.animate(
                with: deathFrames,
                timePerFrame: deathTimePerFrame,
                resize: true,
                restore: true
            ),
            SKAction.sequence([
                SKAction.wait(forDuration: deathTimePerFrame * Double(deathFrames.count)),
                SKAction.removeFromParent()
            ])
        ])
        
        updateState()
        
        zPosition = Layer.zombie
        
        physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: 20,
                height: 35
            )
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.zombie
        physicsBody?.collisionBitMask = Physics.CategoryBitMask.player
            | Physics.CategoryBitMask.groundTile
            | Physics.CategoryBitMask.boundary
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
    }
    
    func update(_ currentTime: TimeInterval) {
        updateState()
        
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
    }
}

// MARK: AnimatedObject
extension Zombie: AnimatedObject {}

// MARK: Zombie
extension Zombie {
    func hitted() {
        guard !isDead else {
            return
        }
        
        isDead = true
    }
}

// MARK: PlayerState
private extension Zombie {
    enum Animations: String {
        case walking
        case idle
        case death
    }
}

// MARK: Private API
private extension Zombie {
    func updateState() {
        if isDead {
            playAnimation(key: Animations.death.rawValue)
        } else {
            isWalking
                ? playAnimation(key: Animations.walking.rawValue)
                : playAnimation(key: Animations.idle.rawValue)
        }
    }
    
    func updateDirection() {
        guard !isDead else {
            return
        }
        
        direction = playerPosition.x > position.x
            ? .right
            : .left
    }
    
    func updatePosition() {
        guard !isDead else {
            return
        }
        
        let moveBy = size.width * 0.07 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
}

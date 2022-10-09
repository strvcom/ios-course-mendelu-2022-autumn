//
//  Zombie.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import SpriteKit

final class Zombie: SKSpriteNode {
    // MARK: Properties
    private let idleFrames = SKTextureAtlas(named: Assets.Atlas.zombieIdle).textures
    private var walkingFrames = SKTextureAtlas(named: Assets.Atlas.zombieWalk).textures
    private var attackFrames = SKTextureAtlas(named: Assets.Atlas.zombieAttack).textures
    private var deathFrames = SKTextureAtlas(named: Assets.Atlas.zombieDeath).textures
    private var velocity: CGFloat = 0
    private var isDead = false
    private var isAttacking = false
    
    private lazy var hurtBox: HurtBox = {
        HurtBox(
            size: CGSize(
                width: 6,
                height: 6
            ),
            position: CGPoint(
                x: 8,
                y: 4
            )
        )
    }()
    
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }
            
            updateNodeDirection(direction: direction)
        }
    }
    
    private var playerPosition: CGPoint {
        levelScene?.player.position ?? .zero
    }
    
    private var distanceToPlayer: CGFloat {
        playerPosition.distance(to: position)
    }
    
    private var isWalking: Bool {
        velocity != 0
    }
    
    private(set) var animations = [String: SKAction]()
    
    private(set) lazy var hitBox: HitBox = {
        HitBox(
            size: CGSize(
                width: 18,
                height: 35
            ),
            position: CGPoint(
                x: -3,
                y: 0
            )
        )
    }()
}

// MARK: GameObject
extension Zombie: SceneObject {
    func setup(scene: LevelScene) {
        setupActions()
        
        setupZombie()
        
        updateState()
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
            velocity = 0
            
            return
        }
        
        updateDirection()
        
        updatePosition()
        
        updateIsAttacking()
    }
}

// MARK: AnimatedObject
extension Zombie: AnimatedObject {}

// MARK: Zombie
extension Zombie {
    func hit() {
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
        case attacking
    }
}

// MARK: Private API
private extension Zombie {
    func setupActions() {
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
                SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.levelScene?.zombieDied(zombie: self)
                    
                    self.removeFromParent()
                }
            ])
        ])
        
        let attackTimePerFrame: TimeInterval = 0.08
        
        animations[Animations.attacking.rawValue] = SKAction.group([
            SKAction.animate(
                with: attackFrames,
                timePerFrame: attackTimePerFrame,
                resize: false,
                restore: true
            ),
            SKAction.sequence([
                SKAction.wait(forDuration: attackTimePerFrame * Double(4)),
                SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.addChild(self.hurtBox)
                },
                SKAction.wait(forDuration: attackTimePerFrame * Double(2)),
                SKAction.run { [weak self] in
                    self?.hurtBox.removeFromParent()
                    
                    self?.isAttacking = false
                }
            ])
        ])
    }
    
    func setupZombie() {
        zPosition = Layer.zombie
        
        physicsBody = SKPhysicsBody(
            rectangleOf: hitBox.size,
            center: hitBox.position
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.zombie
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.zombie
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        
        addChild(hitBox)
    }
    
    func updateState() {
        if isDead {
            playAnimation(key: Animations.death.rawValue)
        } else if isAttacking {
            playAnimation(key: Animations.attacking.rawValue)
        } else {
            isWalking
                ? playAnimation(key: Animations.walking.rawValue)
                : playAnimation(key: Animations.idle.rawValue)
        }
    }
    
    func updateDirection() {
        guard
            !isDead,
            !isAttacking
        else {
            return
        }
        
        direction = playerPosition.x > position.x
            ? .right
            : .left
    }
    
    func updatePosition() {
        guard
            !isDead,
            !isAttacking
        else {
            return
        }
        
        if distanceToPlayer > 200 {
            velocity = 0
        } else {
            velocity = playerPosition.x > position.x
                ? 1
                : -1
        }
        
        let moveBy = size.width * 0.07 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
    
    func updateIsAttacking() {
        guard
            distanceToPlayer < size.width / 2,
            !isAttacking
        else {
            return
        }
        
        isAttacking = true
    }
}

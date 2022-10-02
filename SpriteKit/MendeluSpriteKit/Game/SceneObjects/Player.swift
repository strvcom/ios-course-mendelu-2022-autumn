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
    private var attackFrames = [SKTexture]()
    private var isJumping = false
    private var isAttacking = false
    
    private lazy var hurtBox: SKSpriteNode = {
        let node = SKSpriteNode(
            color: .clear,
            size: CGSize(
                width: 5,
                height: 5
            )
        )
        node.position = CGPoint(
            x: 10,
            y: 7
        )
        return node
    }()
    
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }
            
            updateNodeDirection(direction: direction)
        }
    }
    
    private var velocity: CGFloat {
        levelScene?.joystick.velocity ?? 0
    }
    
    private var isWalking: Bool {
        velocity != 0
    }
    
    private(set) var animations = [String: SKAction]()
}

// MARK: AnimatedObject
extension Player: AnimatedObject {}

// MARK: GameObject
extension Player: SceneObject {
    func setup(scene: LevelScene) {
        
        
        idleFrames = SKTextureAtlas(named: Assets.Atlas.playerIdle).textures
        
        walkingFrames = SKTextureAtlas(named: Assets.Atlas.playerWalk).textures
        
        attackFrames = SKTextureAtlas(named: Assets.Atlas.playerAttack).textures
        
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
        
        let attackTimePerFrame: TimeInterval = 0.08
        
        animations[Animations.attacking.rawValue] = SKAction.group([
            SKAction.run { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.addChild(self.hurtBox)
            },
            SKAction.animate(
                with: attackFrames,
                timePerFrame: attackTimePerFrame,
                resize: false,
                restore: true
            ),
            SKAction.sequence([
                SKAction.wait(forDuration: attackTimePerFrame * Double(attackFrames.count)),
                SKAction.run { [weak self] in
                    self?.hurtBox.removeFromParent()
                    
                    self?.isAttacking = false
                }
            ])
        ])
        
        updateState()
        
        setupPlayer()
    }
    
    func update(_ currentTime: TimeInterval) {
        updateDirection()
        
        updateState()
        
        updatePosition()
        
        updateHurtBox()
    }
    
    func handleContactStart(_ contact: SKPhysicsContact) {
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
    func attack() {
        guard !isAttacking else {
            return
        }
        
        isAttacking = true
    }
    
    func jump() {
        guard !isJumping else {
            return
        }
        
        isJumping = true
        
        physicsBody?.applyImpulse(
            CGVector(
                dx: 0,
                dy: size.height * 0.7
            )
        )
    }
}

// MARK: PlayerState
private extension Player {
    enum Animations: String {
        case walking
        case idle
        case attacking
    }
}

// MARK: Private API
private extension Player {
    func setupPlayer() {
        zPosition = Layer.player
        physicsBody = SKPhysicsBody(
            rectangleOf: CGSize(
                width: 20,
                height: 35
            )
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.player
        physicsBody?.collisionBitMask = Physics.CategoryBitMask.boundary |
            Physics.CategoryBitMask.zombie |
            Physics.CategoryBitMask.groundTile
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.contactTestBitMask = Physics.CategoryBitMask.groundTile
    }
    
    func updateState() {
        if isAttacking {
            playAnimation(key: Animations.attacking.rawValue)
        } else {
            isWalking
                ? playAnimation(key: Animations.walking.rawValue)
                : playAnimation(key: Animations.idle.rawValue)
        }
    }
    
    func updateDirection() {
        if velocity > 0 {
            direction = .right
        } else if velocity < 0 {
            direction = .left
        }
    }
    
    func updatePosition() {
        let moveBy = size.width * 0.2 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
    
    func updateHurtBox() {
        guard
            hurtBox.parent != nil,
            let levelScene = levelScene
        else {
            return
        }
        
        for zombie in levelScene.zombies {
            guard hurtBox.intersects(zombie) else {
                continue
            }
            
            zombie.hitted()
        }
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
            
            isJumping = false
        default:
            break
        }
    }
}

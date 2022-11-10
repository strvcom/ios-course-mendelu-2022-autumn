//
//  Player.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

/// `SKSpriteNode` onscreen graphical element that can be initialized
/// from an image or a solid color.
final class Player: SKSpriteNode {
    // MARK: Static
    static let playerLifes = 3

    // MARK: Private Properties
    private let idleFrames = SKTextureAtlas(named: Assets.Atlas.playerIdle).textures
    private let walkingFrames = SKTextureAtlas(named: Assets.Atlas.playerWalk).textures
    private let attackFrames = SKTextureAtlas(named: Assets.Atlas.playerAttack).textures
    private let deathFrames = SKTextureAtlas(named: Assets.Atlas.playerDeath).textures
    private var isJumping = false
    private var isAttacking = false
    private var isHurt = false

    private var lifes: Int = Player.playerLifes {
        didSet {
            levelScene?.playerLifes.hearts[max(0, lifes)].alpha = 0.5
        }
    }
     
    /// Hutbox positioned to player hand when attacking.
    private lazy var hurtBox: HurtBox = {
        HurtBox(
            size: CGSize(
                width: 5,
                height: 5
            ),
            position: CGPoint(
                x: 10,
                y: 4
            )
        )
    }()
    
    /// Direction, where player is facing towards.
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
    
    private var isDead: Bool {
        lifes == .zero
    }
    
    private(set) var animations = [String: SKAction]()
    
    /// Hitbox positioned to player physics body.
    private(set) lazy var hitbox: HitBox = {
        HitBox(
            size: CGSize(
                width: 20,
                height: 35
            ),
            position: CGPoint(
                x: 0,
                y: -2
            )
        )
    }()
}

// MARK: AnimatedObject
extension Player: AnimatedObject {}

// MARK: GameObject
extension Player: SceneObject {
    func setup(scene: LevelScene) {
        setupActions()
        
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
        // We can jump only when isJumping is set to false, otherwise we would
        // be able to jump in the air.
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
    
    func hit() {
        guard isHurt == false else {
            return
        }
        
        isHurt = true
        
        lifes -= 1

        // Start player blinking upon taking damage. In this state, player
        // is invulnerable, which means that he / she can't take damage.
        run(
            SKAction.sequence([
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.fadeOut(withDuration: 0.1),
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.fadeOut(withDuration: 0.1),
                SKAction.fadeIn(withDuration: 0.1),
                SKAction.wait(forDuration: 1.0),
                SKAction.run { [weak self] in
                    self?.isHurt = false
                }
            ])
        )
    }
}

// MARK: Animations
private extension Player {
    enum Animations: String {
        case walking
        case idle
        case attacking
        case death
    }
}

// MARK: Private API
private extension Player {
    func setupPlayer() {
        addChild(hitbox)
        
        zPosition = Layer.player
        
        physicsBody = SKPhysicsBody(
            texture: SKTexture(imageNamed: Assets.Image.playerPhysicsBody),
            // Physics body has same size as hitbox.
            size: hitbox.size
        )

        physicsBody?.categoryBitMask = Physics.CategoryBitMask.player
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.player
        physicsBody?.contactTestBitMask = Physics.ContactTestBitMask.player
        // Prevents boucing when falling to ground.
        physicsBody?.restitution = 0
        // If allowsRotatin woudl be true, than there is a possibility that player
        // could fall to one side.
        physicsBody?.allowsRotation = false
    }
    
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
        
        animations[Animations.death.rawValue] = SKAction.group([
            SKAction.run { [weak self] in
                // We set physicsBody to nil, because we don't want to
                // be able to interact with other objects in physics world
                // upon death.
                self?.physicsBody = nil
            },
            SKAction.animate(
                with: deathFrames,
                timePerFrame: 0.5,
                resize: true,
                restore: true
            ),
            SKAction.sequence([
                SKAction.wait(forDuration: 0.5 * Double(deathFrames.count)),
                SKAction.run { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.levelScene?.playerDied()
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
            // Hurbox is only going to be shown between 4th and last frame.
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
    
    /// Handles animation state according values. If you want to implement this functionality clearer,
    /// use [GKStateMachine](https://developer.apple.com/documentation/gameplaykit/gkstatemachine).
    ///
    /// Animations have priority and we play them after certain coditions are met.
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
        if velocity > 0 {
            direction = .right
        } else if velocity < 0 {
            direction = .left
        }
    }
    
    func updatePosition() {
        guard isDead == false else { return }
        let moveBy = size.width * 0.2 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
    
    /// Evaluates, if `hurtbox` hitted something.
    func updateHurtBox() {
        guard
            // Only evaluate, when hurbox is actually visible.
            hurtBox.parent != nil,
            let levelScene = levelScene
        else {
            return
        }
        
        for zombie in levelScene.zombies {
            guard hurtBox.intersects(zombie.hitBox) else {
                continue
            }
            
            zombie.hit()
        }
    }
    
    func handleContactWith(
        body: SKPhysicsBody,
        contact: SKPhysicsContact
    ) {
        switch body.node?.name {
        case ObjectNames.tile:
            // Contactnormal > 0 indicates that player hit the ground with legs.
            guard contact.contactNormal.dy > 0 else {
                return
            }
            
            isJumping = false
        case ObjectNames.door:
            guard let door = body.node as? Door else {
                return
            }

            levelScene?.playerEnteredDoor()
            
            door.entered()
        default:
            break
        }
    }
}

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
    /// Same as `Joystick` velocity, indicates, how fast and where is zombie moving.
    private var velocity: CGFloat = 0
    private var isDead = false
    private var isAttacking = false
    
    /// Hutbox positioned to zombie hands when attacking.
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
    
    /// Direction, where zombie is facing towards.
    private var direction: Direction = .right {
        didSet {
            guard oldValue != direction else {
                return
            }
            
            updateNodeDirection(direction: direction)
        }
    }

    private var isWalking: Bool {
        velocity != 0
    }
    
    private(set) var animations = [String: SKAction]()
    
    /// Hitbox positioned to zombie physics body.
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
        
        // Zombie is by default in idle braindead state, until there is
        // player around.
        guard
            // First, we send ray to player position, which returns the first
            // physics body along its way.
            let body = levelScene?.physicsWorld.body(
                alongRayStart: position,
                end: playerPosition
            ),
            // When the physics body is player, then we can start moving zombie.
            body.categoryBitMask == Physics.CategoryBitMask.player
        else {
            // Otherwise, zombie just stay in one place.
            velocity = 0
            
            return
        }
        
        updateDirection()
        
        updatePosition()
        
        updateIsAttacking()
        
        updateHurtBox()
    }
}

// MARK: PlayerReactiveObject
extension Zombie: PlayerObservingObject {}

// MARK: AnimatedObject
extension Zombie: AnimatedObject {}

// MARK: Zombie
extension Zombie {
    /// Call, when zombie should be hit by something. Zombie has only one life, so
    /// he dies immediatelly after one hit.
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
                // We set physicsBody to nil, because we don't want zombie to
                // be able to interact with other objects in physics world
                // upon death.
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
    
    func setupZombie() {
        zPosition = Layer.zombie
        
        physicsBody = SKPhysicsBody(
            rectangleOf: hitBox.size,
            center: hitBox.position
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.zombie
        physicsBody?.collisionBitMask = Physics.CollisionBitMask.zombie
        // Prevents boucing when coliding with some other object.
        physicsBody?.restitution = 0
        // If allowsRotatin would be true, than there is a possibility that node
        // could fall to one side.
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
    
    /// Updates zombie direction to face player.
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
    
    /// Updates zombie position to walk to player.
    func updatePosition() {
        guard
            !isDead,
            !isAttacking
        else {
            return
        }
        
        // When player is far, zombie is too lazy to go, he waits until
        // there is player close enough.
        if distanceToPlayer > 200 {
            velocity = 0
        } else {
            // After player moved closer, zombie starts to walk towards him / her.
            velocity = playerPosition.x > position.x
                ? 1
                : -1
        }
        
        // Calculated zombie speed.
        let moveBy = size.width * 0.07 * velocity
        
        position = CGPoint(
            x: position.x + moveBy,
            y: position.y
        )
    }
    
    /// Updates zombie to attacking state. When player is close enought to zombie, we
    /// can switch `isAttacking` value to `true`.
    func updateIsAttacking() {
        guard
            // This indicates that player is in contact with zombie, becuase
            // distance to player is point from center of zombie node.
            distanceToPlayer < size.width / 2,
            !isAttacking
        else {
            return
        }
        
        isAttacking = true
    }
    
    /// Evaluates, if `hurtbox` hitted something.
    func updateHurtBox() {
        guard
            hurtBox.parent != nil,
            let levelScene = levelScene
        else {
            return
        }
        
        guard
            let player = levelScene.player,
            hurtBox.intersects(player.hitbox)
        else {
            return
        }
        
        levelScene.player.hit()
    }
}

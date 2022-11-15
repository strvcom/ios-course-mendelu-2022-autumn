//
//  Player.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

final class Player: SKSpriteNode {
    // MARK: Properties
    // TODO: Add Properties
}

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
        // TODO: Implement Player Attack
    }
    
    func jump() {
        // TODO: Implement Player Jump
    }
    
    func hit() {
        // TODO: Implement Player Hit
    }
}

// MARK: Private API
private extension Player {
    func setupPlayer() {
        // TODO: Implement setupPlayer
    }
    
    func setupActions() {
        // TODO: Implement setupActions
    }
    
    /// Handles animation state according values. If you want to implement this functionality clearer,
    /// use [GKStateMachine](https://developer.apple.com/documentation/gameplaykit/gkstatemachine).
    ///
    /// Animations have priority and we play them after certain coditions are met.
    func updateState() {
        // TODO: Implement State Update
    }
    
    func updateDirection() {
        // TODO: Implement updateDirection
    }
    
    func updatePosition() {
        // TODO: Implement updateDirection
    }
    
    /// Evaluates, if `hurtbox` hitted something.
    func updateHurtBox() {
        // TODO: Implement updateHurtBox
    }
    
    func handleContactWith(
        body: SKPhysicsBody,
        contact: SKPhysicsContact
    ) {
        // TODO: Implement handleContactWith
    }
}

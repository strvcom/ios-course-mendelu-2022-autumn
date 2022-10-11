//
//  Door.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 05.10.2022.
//

import SpriteKit

final class Door: SKSpriteNode {
    // MARK: Properties
    private let openingDoorFrames = SKTextureAtlas(named: Assets.Atlas.doorOpening).textures
    private var isOpen: Bool = false

    private(set) var animations = [String: SKAction]()
}

// MARK: Game Object
extension Door: SceneObject {
    func setup(scene: LevelScene) {
        setupDoor()
        setupActions()
    }

    func update(_ currentTime: TimeInterval) {
        updateState()
    }
}

// MARK: PlayerReactiveObject
extension Door: PlayerObservingObject {}

// MARK: Animation
private extension Door {
    enum Animations: String {
        case open // player comes to close proximity
        case close // player leaves close proximity
    }
}

// MARK: Constants
private extension Door {
    enum Images {
        static let closedDoorImage = UIImage(named: "ClosedDoor")!
        static let openedDoorImage = UIImage(named: "OpenedDoor")!
    }
}

// MARK: AnimatedObject
extension Door: AnimatedObject {}

// MARK: Private API
private extension Door {

    func setupDoor() {
        zPosition = Layer.door
        texture = SKTexture(image: Images.closedDoorImage)
        name = ObjectNames.door

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 10), center: CGPoint(x: -self.size.width/4, y: 0))
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 0
    }

    func setupActions() {
        let frameTimeInterval: TimeInterval = 0.08

        animations[Animations.open.rawValue] = SKAction.animate(
            with: openingDoorFrames,
            timePerFrame: frameTimeInterval,
            resize: false,
            restore: false
        )

        animations[Animations.close.rawValue] = SKAction.animate(
            with: openingDoorFrames.reversed(),
            timePerFrame: frameTimeInterval,
            resize: false,
            restore: false
        )
    }

    func updateState() {
        
        if distanceToPlayer <= 80 {
            if !isOpen {
                playAnimation(key: Animations.open.rawValue)
                isOpen = true
            }
        } else {
            if isOpen {
                playAnimation(key: Animations.close.rawValue)
                isOpen = false
            }
        }
    }
}

//
//  Door.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 05.10.2022.
//

import SpriteKit

final class Door: SKSpriteNode {
    private let openingDoorFrames = SKTextureAtlas(named: Assets.Atlas.doorOpening).textures
    private var isOpen: Bool = false
}

extension Door: SceneObject {
    
    func setup(scene: LevelScene) {
        setupDoor()
        setupActions()
    }

    func handleContactStart(_ contact: SKPhysicsContact) {
        // TODO: Open the door
    }

    func handleContactEnd(_ contact: SKPhysicsContact) {
        // TODO: Close the door
    }
}

// MARK: Animation
private extension Door {
    enum Animations {
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

// MARK: Private API
private extension Door {

    var playerPosition: CGPoint {
        levelScene?.player.position ?? .zero
    }

    var distanceToPlayer: CGFloat {
        playerPosition.distance(to: position)
    }

    func setupDoor() {
        zPosition = Layer.door
        texture = SKTexture(image: Images.closedDoorImage)
    }

    func setupActions() {
        
    }
}

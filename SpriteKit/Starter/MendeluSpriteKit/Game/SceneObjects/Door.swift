//
//  Door.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 05.10.2022.
//

import SpriteKit

final class Door: SKSpriteNode {
    // MARK: Properties
}

// MARK: Game Object
extension Door: SceneObject {
    func setup(scene: LevelScene) {
        setupDoor()
        
        setupActions()
    }

    func update(_ currentTime: TimeInterval) {
        // TODO: Implement update
    }
}

// MARK: Private API
private extension Door {
    func setupDoor() {
        // TODO: Implement setupDoor
    }

    func setupActions() {
        // TODO: Implement setupActions
    }

    func updateState() {
        // TODO: Implement updateState
    }
}

//
//  Fountain.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 04.10.2022.
//

import SpriteKit

final class Fountain: SKSpriteNode {
    // MARK: Properties
    private let waterFlowFrames = SKTextureAtlas(named: Assets.Atlas.fountainFlowing).textures

    private(set) var animations = [String : SKAction]()
}

// MARK: SceneObject
extension Fountain: SceneObject {
    func setup(scene: LevelScene) {
        setupAction()

        setupFountain()
    }

    func update(_ currentTime: TimeInterval) {
        playAnimation(key: Animations.flowing.rawValue)
    }
}

// MARK: AnimatedObject
extension Fountain: AnimatedObject {}

private extension Fountain {
    enum Animations: String {
        case flowing
    }
}

private extension Fountain {
    func setupFountain() {
        zPosition = Layer.fountain
    }

    func setupAction() {
        let timePerFrame: TimeInterval = 0.12

        animations[Animations.flowing.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: waterFlowFrames,
                timePerFrame: timePerFrame,
                resize: false,
                restore: true
            )
        )
    }
}

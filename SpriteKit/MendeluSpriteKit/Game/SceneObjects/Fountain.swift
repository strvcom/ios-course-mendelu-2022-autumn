//
//  Fountain.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 04.10.2022.
//

import SpriteKit

final class Fountain: SKSpriteNode {
    // MARK: Properties
    private let fountainFlowFrames = SKTextureAtlas(named: Assets.Atlas.fountainFlowing).textures

    private(set) var animations = [String : SKAction]()
}

// MARK: SceneObject
extension Fountain: SceneObject {
    func setup(scene: LevelScene) {
        setupAction()

        setupFountain()
    }

    func update(_ currentTime: TimeInterval) {
        playAnimation(key: Animations.fountainFlowing.rawValue)
    }
}

// MARK: AnimatedObject
extension Fountain: AnimatedObject {}

private extension Fountain {
    enum Animations: String {
        case fountainFlowing
    }
}

private extension Fountain {
    func setupFountain() {
        zPosition = Layer.fountain
    }

    func setupAction() {
        let timePerFrame: TimeInterval = 0.12

        animations[Animations.fountainFlowing.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: fountainFlowFrames,
                timePerFrame: timePerFrame,
                resize: false,
                restore: true
            )
        )
    }
}

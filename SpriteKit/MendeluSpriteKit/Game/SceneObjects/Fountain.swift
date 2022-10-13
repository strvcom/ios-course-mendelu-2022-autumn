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

// MARK: Animations
private extension Fountain {
    enum Animations: String {
        case fountainFlowing
    }
}

// MARK: Private API
private extension Fountain {
    func setupFountain() {
        zPosition = Layer.fountain
    }

    func setupAction() {
        animations[Animations.fountainFlowing.rawValue] = SKAction.repeatForever(
            SKAction.animate(
                with: fountainFlowFrames,
                timePerFrame: 0.12,
                resize: false,
                restore: true
            )
        )
    }
}

//
//  PlayerLifes.swift
//  MendeluSpriteKit
//
//  Created by Raul Batista on 08.10.2022.
//

import SpriteKit
import UIKit

/// UI representing player lifes on top right side of the screen.
final class PlayerLifes: SKNode {
    // MARK: Private properties
    private var backgroundNode: SKShapeNode?
    
    /// Represent size of one heart.
    private var size: CGFloat {
        (levelScene?.size.height ?? 0) * 0.13
    }

    // MARK: Public properties
    var hearts: [SKSpriteNode] = []
}

// MARK: SceneObject
extension PlayerLifes: SceneObject {
    func setup(scene: LevelScene) {
        // TODO: Implement hearts
    }
}

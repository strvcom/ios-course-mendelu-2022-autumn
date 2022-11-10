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
        scene.cameraObject.addChild(self)
        
        zPosition = Layer.controls
        
        let corner = scene.cameraObject.bottomLeftCorner

        // We create as many of hearts as player has number of lifes.
        for index in 0...Player.playerLifes - 1 {
            let heart = SKSpriteNode(
                texture: SKTexture(image: UIImage(named: Assets.Image.playerLife) ?? UIImage())
            )
            heart.zPosition = zPosition
            heart.size = CGSize(size: 40)
            heart.position = CGPoint(
                x: corner.x + CGFloat(index * 45),
                y: (corner.y + UIScreen.main.bounds.height / 1.5) + 75
            )

            addOptionalChild(heart)
            
            hearts.append(heart)
        }
    }
}

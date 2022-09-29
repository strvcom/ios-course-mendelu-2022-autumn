//
//  Background.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

final class Background {
    // MARK: Properties
    private var backgrounds: [(backgroundName: String, layer: CGFloat)] {
        [
            (Assets.Image.background1, Layer.background1),
            (Assets.Image.background2, Layer.background2),
            (Assets.Image.background3, Layer.background3),
            (Assets.Image.background4, Layer.background4)
        ]
    }
}

// MARK: GameObject
extension Background: GameObject {
    func setup(gameScene: GameScene) {
        backgrounds
            .forEach {
                let background = SKSpriteNode(imageNamed: $0.backgroundName)
                background.anchorPoint = .zero
                background.position = CGPoint(
                    x: 0,
                    y: gameScene.ground.tileSize.height
                )
                background.zPosition = $0.layer
                background.size = gameScene.size
                
                gameScene.addChild(background)
            }
    }
}

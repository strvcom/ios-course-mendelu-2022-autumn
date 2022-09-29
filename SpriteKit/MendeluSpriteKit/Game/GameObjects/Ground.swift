//
//  Ground.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

final class Ground {
    // MARK: Properties
    private weak var gameScene: GameScene?
    
    private(set) lazy var tileSize = UIImage(named: Assets.Image.tile)?.size ?? .zero
    
    var groundWidth: CGFloat {
        (gameScene?.size.width ?? 0) * 3
    }
}

// MARK: GameObject
extension Ground: GameObject {
    func setup(gameScene: GameScene) {
        self.gameScene = gameScene
        
        var totalGroundWidth: CGFloat = 0
        
        while totalGroundWidth <= self.groundWidth {
            let tile = SKSpriteNode(imageNamed: Assets.Image.tile)
            tile.position = CGPoint(
                x: totalGroundWidth,
                y: 0
            )
            tile.anchorPoint = .zero
            tile.zPosition = Layer.tiles
            tile.size = tileSize
            tile.physicsBody = SKPhysicsBody(
                rectangleOf: tileSize,
                center: CGPoint(
                    x: tileSize.width * 0.5,
                    y: tileSize.height * 0.5
                )
            )
            tile.physicsBody?.categoryBitMask = Physics.CategoryBitMask.groundTile
            tile.physicsBody?.isDynamic = false
            tile.physicsBody?.restitution = 0
            
            gameScene.addChild(tile)
            
            totalGroundWidth += tileSize.width
        }
    }
}

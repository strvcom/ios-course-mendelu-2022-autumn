//
//  Ground.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 29.09.2022.
//

import SpriteKit

final class Ground {
    // MARK: Properties
    let ground: SKTileMapNode
    
    // MARK: Init
    init(ground: SKTileMapNode) {
        self.ground = ground
    }
}

// MARK: GameObject
extension Ground: GameObject {
    func setup(gameScene: GameScene) {        
        for columnNumber in 0 ..< ground.numberOfColumns {
            for rowNumber in 0 ..< ground.numberOfColumns {
                let definition = ground.tileDefinition(
                    atColumn: columnNumber,
                    row: rowNumber
                )
                
                guard definition != nil else {
                    continue
                }
                
                let xPosition = ground.tileSize.width * CGFloat(columnNumber)
                
                let yPosition = ground.tileSize.height * CGFloat(rowNumber)
                
                let node = SKSpriteNode(
                    color: .clear,
                    size: ground.tileSize
                )
                node.zPosition = 40
                node.position = CGPoint(
                    x: xPosition,
                    y: yPosition
                )
                node.anchorPoint = .zero
                node.physicsBody = SKPhysicsBody(
                    rectangleOf: ground.tileSize,
                    center: CGPoint(
                        x: ground.tileSize.width * 0.5,
                        y: ground.tileSize.height * 0.5
                    )
                )
                node.physicsBody?.isDynamic = false
                node.physicsBody?.restitution = 0
                node.physicsBody?.categoryBitMask = Physics.CategoryBitMask.groundTile
                
                gameScene.addChild(node)
            }
        }
    }
}

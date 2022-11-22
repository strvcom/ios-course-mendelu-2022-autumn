//
//  Level.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 29.09.2022.
//

import SpriteKit

final class Level {
    // MARK: Properties
    /// `SKTileMapNode` which represents ground. It consits only from `Tiles`.
    let ground: SKTileMapNode
    
    // MARK: Init
    init(ground: SKTileMapNode) {
        self.ground = ground
    }
}

// MARK: GameObject
extension Level: SceneObject {
    func setup(scene: LevelScene) {
        addPhysicsToTileMapNodes(scene: scene)
        
        // TODO: Create boundaries
    }
}

// MARK: Private API
private extension Level {
    /// Adds physics to every tile node in scene.
    ///
    /// Due to spritekit limitations, we are not able to easily say, that each tile should have some kind of
    /// physics category, so we have to implement this functionality by ourselfs.
    func addPhysicsToTileMapNodes(scene: LevelScene) {
        for columnNumber in 0 ..< ground.numberOfColumns {
            for rowNumber in 0 ..< ground.numberOfRows {
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
                node.name = ObjectNames.tile
                node.zPosition = Layer.tiles
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
                node.physicsBody?.collisionBitMask = Physics.CollisionBitMask.groundTile
                
                scene.addChild(node)
            }
        }
    }
    
    func createBoundarySprite(
        size: CGSize,
        position: CGPoint,
        scene: LevelScene
    ) {
        // TODO: Implement Boundary SpriteNode
    }
}

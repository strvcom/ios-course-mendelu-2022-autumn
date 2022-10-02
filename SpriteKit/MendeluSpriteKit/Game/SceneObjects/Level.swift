//
//  Level.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 29.09.2022.
//

import SpriteKit

final class Level {
    // MARK: Properties
    let ground: SKTileMapNode
    
    // MARK: Init
    init(ground: SKTileMapNode) {
        self.ground = ground
    }
}

// MARK: GameObject
extension Level: SceneObject {
    func setup(scene: LevelScene) {
        ground.zPosition = Layer.tiles
        
        for child in scene.children {
            guard child.name == ObjectNames.scenery else {
                continue
            }
            
            child.zPosition = Layer.scenery
        }
        
        addPhysicsToTileMapNodes(scene: scene)
        
        createTopBoundary(scene: scene)
        
        createLeftBoundary(scene: scene)
        
        createRightBoundary(scene: scene)
        
        createBottomBoundary(scene: scene)
    }
}

// MARK: Private API
private extension Level {
    func addPhysicsToTileMapNodes(scene: LevelScene) {
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
                node.physicsBody?.collisionBitMask = Physics.CategoryBitMask.player |
                    Physics.CategoryBitMask.zombie
                
                scene.addChild(node)
            }
        }
    }
    
    func createTopBoundary(scene: LevelScene) {
        let height: CGFloat = 1
        
        let width: CGFloat = scene.level.ground.mapSize.width
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: 0,
                y: scene.level.ground.mapSize.height + height
            ),
            scene: scene
        )
    }
    
    func createLeftBoundary(scene: LevelScene) {
        let height = scene.level.ground.mapSize.height
        
        let width: CGFloat = 1
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: -width,
                y: 0
            ),
            scene: scene
        )
    }
    
    func createRightBoundary(scene: LevelScene) {
        let height = scene.level.ground.mapSize.height
        
        let width: CGFloat = 1
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: scene.level.ground.mapSize.width,
                y: 0
            ),
            scene: scene
        )
    }
    
    func createBottomBoundary(scene: LevelScene) {
        let height: CGFloat = 1
        
        let width: CGFloat = scene.level.ground.mapSize.width
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: 0,
                y: -height
            ),
            scene: scene
        )
    }
    
    func createBoundarySprite(
        size: CGSize,
        position: CGPoint,
        scene: LevelScene
    ) {
        let node = SKSpriteNode(
            color: .clear,
            size: size
        )
        node.position = position
        node.anchorPoint = .zero
        node.physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: size.width * 0.5,
                y: size.height * 0.5
            )
        )
        node.physicsBody?.isDynamic = false
        node.physicsBody?.restitution = 0
        node.physicsBody?.categoryBitMask = Physics.CategoryBitMask.boundary
        node.physicsBody?.collisionBitMask = Physics.CategoryBitMask.player |
            Physics.CategoryBitMask.zombie
        
        scene.addChild(node)
    }
}

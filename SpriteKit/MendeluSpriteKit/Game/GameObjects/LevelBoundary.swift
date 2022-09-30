//
//  LevelBoundary.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 30.09.2022.
//

import SpriteKit

final class LevelBoundary {}

// MARK: GameObject
extension LevelBoundary: GameObject {
    func setup(gameScene: LevelScene) {
        createTopBoundary(gameScene: gameScene)
        
        createLeftBoundary(gameScene: gameScene)
        
        createRightBoundary(gameScene: gameScene)
        
        createBottomBoundary(gameScene: gameScene)
    }
}


// MARK: Private API
private extension LevelBoundary {
    func createTopBoundary(gameScene: LevelScene) {
        let height: CGFloat = 1
        
        let width: CGFloat = gameScene.ground.ground.mapSize.width
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: 0,
                y: gameScene.ground.ground.mapSize.height + height
            ),
            gameScene: gameScene
        )
    }
    
    func createLeftBoundary(gameScene: LevelScene) {
        let height = gameScene.ground.ground.mapSize.height
        
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
            gameScene: gameScene
        )
    }
    
    func createRightBoundary(gameScene: LevelScene) {
        let height = gameScene.ground.ground.mapSize.height
        
        let width: CGFloat = 1
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: gameScene.ground.ground.mapSize.width,
                y: 0
            ),
            gameScene: gameScene
        )
    }
    
    func createBottomBoundary(gameScene: LevelScene) {
        let height: CGFloat = 1
        
        let width: CGFloat = gameScene.ground.ground.mapSize.width
        
        createBoundarySprite(
            size: CGSize(
                width: width,
                height: height
            ),
            position: CGPoint(
                x: 0,
                y: -height
            ),
            gameScene: gameScene
        )
    }
    
    func createBoundarySprite(
        size: CGSize,
        position: CGPoint,
        gameScene: LevelScene
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
        
        gameScene.addChild(node)
    }
}

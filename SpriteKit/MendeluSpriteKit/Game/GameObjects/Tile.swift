//
//  Tile.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 29.09.2022.
//

import SpriteKit

final class Tile: SKSpriteNode {}

// MARK: Constants
extension Tile {
    static let name = "tile"
}

// MARK: GameObject
extension Tile: GameObject {
    func setup(gameScene: LevelScene) {
        name = Self.name
        zPosition = Layer.tiles
        physicsBody = SKPhysicsBody(
            rectangleOf: size,
            center: CGPoint(
                x: size.width * 0.5,
                y: size.height * 0.5
            )
        )
        physicsBody?.categoryBitMask = Physics.CategoryBitMask.groundTile
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 0
    }
}

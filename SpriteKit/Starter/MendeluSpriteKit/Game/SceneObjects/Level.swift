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
        // TODO: Add physics to SKTileMapNodes
    }
    
    func createBoundarySprite(
        size: CGSize,
        position: CGPoint,
        scene: LevelScene
    ) {
        // TODO: Implement Boundary SpriteNode
    }
}

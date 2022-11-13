//
//  Camera.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 26.09.2022.
//

import SpriteKit

/// Camera represents `camera` object in `LevelScene`. It's centered on `Player` and contains the entire game UI.
final class Camera: SKCameraNode {
    // MARK: Properties
    private var safeArea: UIEdgeInsets {
        scene?.view?.safeAreaInsets ?? .zero
    }
    
    private var sceneSize: CGSize {
        scene?.size ?? .zero
    }
    
    var cameraSize: CGSize {
        CGSize(
            width: sceneSize.width * xScale,
            height: sceneSize.height * yScale
        )
    }
    
    var bottomLeftCorner: CGPoint {
        CGPoint(
            x: -(sceneSize.width / 2) + safeArea.left,
            y: -(sceneSize.height / 2) + safeArea.bottom
        )
    }
    
    var bottomRightCorner: CGPoint {
        CGPoint(
            x: (sceneSize.width / 2) - safeArea.right,
            y: -(sceneSize.height / 2) + safeArea.bottom
        )
    }
}

// MARK: GameObject
extension Camera: SceneObject {
    func setup(scene: LevelScene) {
        scene.camera = self
        scene.addChild(self)
        
        // We can change camera size only with xScale and yScale,
        // we cannot provide concrete CGSize.
        xScale = 0.5
        yScale = 0.5
    }
    
    func update(_ currentTime: TimeInterval) {
        guard
            let playerPosition = levelScene?.player.position,
            let boundingRectangle = calculateBoundingRectangle()
        else {
            return
        }

        let widthRange = (boundingRectangle.minX ... boundingRectangle.minX + boundingRectangle.width)

        let heightRange = (boundingRectangle.minY ... boundingRectangle.minY + boundingRectangle.height)

        // Because we want to center camera to player, but not leave bounds,
        // we will clamp player position to boundingRectangle.
        position = CGPoint(
            x: playerPosition.x.clamped(to: widthRange),
            y: playerPosition.y.clamped(to: heightRange)
        )
    }
    
    /// Returns rectangle, from which camera shouldn't move. It is used to restrict camera position, so that it
    /// won't leave level bounds. You can imagine that it looks like a little bit smaller map rectangle.
    func calculateBoundingRectangle() -> CGRect? {
        guard let mapSize = levelScene?.level.ground.mapSize else {
            return nil
        }
        
        return CGRect(
            x: cameraSize.width / 2,
            y: cameraSize.height / 2,
            width: mapSize.width - cameraSize.width,
            height: mapSize.height - cameraSize.height
        )
    }
}

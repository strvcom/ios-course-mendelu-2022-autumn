//
//  Camera.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 26.09.2022.
//

import SpriteKit

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
        
        xScale = 0.7
        yScale = 0.7
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

        position = CGPoint(
            x: playerPosition.x.clamped(to: widthRange),
            y: playerPosition.y.clamped(to: heightRange)
        )
    }
    
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

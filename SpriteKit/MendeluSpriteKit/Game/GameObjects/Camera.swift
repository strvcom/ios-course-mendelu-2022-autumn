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
    
    private var cameraSize: CGSize {
        CGSize(
            width: sceneSize.width * xScale,
            height: sceneSize.height * yScale
        )
    }
    
    private var sceneSize: CGSize {
        scene?.size ?? .zero
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
extension Camera: GameObject {
    func setup(gameScene: LevelScene) {
        gameScene.camera = self
        gameScene.addChild(self)
        
        xScale = 0.7
        yScale = 0.7
    }
    
    func update(_ currentTime: TimeInterval) {
        guard
            let playerPosition = gameScene?.player.position,
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
        guard let mapSize = gameScene?.ground.ground.mapSize else {
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

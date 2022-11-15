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
        
        // TODO: Change camera size
    }
    
    func update(_ currentTime: TimeInterval) {
        // TODO: Center camera to player
    }
    
    func calculateBoundingRectangle() -> CGRect? {
        // TODO: Calculate bounding rectangle
        nil
    }
}

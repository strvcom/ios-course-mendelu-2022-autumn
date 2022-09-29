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
    
    private var leftCameraConstraint: CGFloat {
        0
    }
    
    private var rightCameraConstraint: CGFloat {
        sceneSize.width
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
    func setup(gameScene: GameScene) {
        gameScene.camera = self
        gameScene.addChild(self)
        
//        xScale = 0.7
//        yScale = 0.7
    }
    
    func update(_ currentTime: TimeInterval) {
        position = CGPoint(
            x: calculateXPosition(),
            y: calculateYPosition()
        )
    }
    
    func calculateXPosition() -> CGFloat {
        let leftCameraConstraint = (scene?.size.width ?? 0) / 2
        
        let rightCameraConstraint = sceneSize.width
        
        let xPosition = gameScene?.player.position.x ?? 0
        
        if xPosition < leftCameraConstraint {
            return leftCameraConstraint
        } else if xPosition > rightCameraConstraint {
            return rightCameraConstraint
        } else {
            return xPosition
        }
    }
    
    func calculateYPosition() -> CGFloat {
        let halfOfCameraHeight = ((scene?.size.height ?? 0) * yScale) / 2
        
        let topCameraConstraint = (scene?.size.height ?? 0)
        
        let bottomCameraConstraint: CGFloat = 0
        
        let yPosition = gameScene?.player.position.y ?? 0
        
        if yPosition + halfOfCameraHeight > topCameraConstraint {
            return topCameraConstraint - halfOfCameraHeight
        } else if yPosition - halfOfCameraHeight < bottomCameraConstraint {
            return halfOfCameraHeight
        } else {
            return yPosition
        }
    }
}

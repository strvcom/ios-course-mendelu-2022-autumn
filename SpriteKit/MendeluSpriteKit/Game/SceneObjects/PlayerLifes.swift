//
//  PlayerLifes.swift
//  MendeluSpriteKit
//
//  Created by Raul Batista on 08.10.2022.
//

import SpriteKit
import UIKit

final class PlayerLifes: SKNode {
    let image = UIImage(named: Assets.Image.playerLife)
    
    var hearts: [SKSpriteNode] = []
    
    var backgroundNode: SKShapeNode?
    
    private var size: CGFloat {
        (levelScene?.size.height ?? 0) * 0.13
    }
}

extension PlayerLifes: SceneObject {
    func setup(scene: LevelScene) {
        scene.cameraObject.addChild(self)
        
        zPosition = Layer.controls
        
        let topLeft = scene.cameraObject.bottomLeftCorner

        for index in 0...Player.playerLifes - 1 {
            let heart = SKSpriteNode(texture: SKTexture(image: image ?? UIImage()))
            heart.zPosition = zPosition
            heart.size = CGSize(width: 40, height: 40)
            heart.position = CGPoint(
                x: topLeft.x + CGFloat(index * 45),
                y: (topLeft.y + UIScreen.main.bounds.height / 1.5) + 75
            )
            
            addOptionalChild(heart)
            hearts.append(heart)
        }
    }
}

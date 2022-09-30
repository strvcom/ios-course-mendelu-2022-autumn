//
//  JumpButton.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

import SpriteKit

final class JumpButton: SKNode {
    // MARK: Properties
    private var size: CGFloat {
        (levelScene?.size.height ?? 0) * 0.13
    }
    
    // MARK: Overrides
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        levelScene?.player.jump()
    }
    
    func keyboardUp(presses: Set<UIPress>) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == " " {
                levelScene?.player.jump()
            }
        }
    }
}

// MARK: GameObject
extension JumpButton: SceneObject {
    func setup(scene: LevelScene) {
        scene.cameraObject.addChild(self)

        isUserInteractionEnabled = true
        
        let button = SKShapeNode(circleOfRadius: size / 2)
        button.fillColor = .black
        button.strokeColor = .white
        
        addChild(button)
        
        zPosition = Layer.controls
        
        let bottomRight = scene.cameraObject.bottomRightCorner
        
        position = CGPoint(
            x: bottomRight.x - size * 1.3,
            y: bottomRight.y + size * 1.3
        )
    }
}

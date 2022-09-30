//
//  ContolButtons.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 30.09.2022.
//

import SpriteKit

final class ControlButtons: SKSpriteNode {
    private var jumpButton: JumpButton!
    private var attackButton: AttackButton!
    
    // MARK: Overrides
    func keyboardUp(presses: Set<UIPress>) {
        jumpButton.keyboardUp(presses: presses)
        
        attackButton.keyboardUp(presses: presses)
    }
}
// MARK: GameObject
extension ControlButtons: SceneObject {
    func setup(scene: LevelScene) {
        scene.cameraObject.addChild(self)
        
        color = .clear
        zPosition = Layer.controls
        
        let buttonSize = scene.size.height * 0.13
        
        size = CGSize(
            width: 4 * buttonSize,
            height: 4 * buttonSize
        )
        position = CGPoint(
            x: scene.cameraObject.bottomRightCorner.x - 75,
            y: scene.cameraObject.bottomRightCorner.y + (size.width / 2)
        )
        
        jumpButton = JumpButton(circleOfRadius: buttonSize / 2)
        jumpButton.isUserInteractionEnabled = true
        jumpButton.fillColor = .black
        jumpButton.strokeColor = .white
        jumpButton.position = CGPoint(
            x: 0,
            y: -buttonSize * 1.2
        )
        
        addChild(jumpButton)
        
        attackButton = AttackButton(circleOfRadius: buttonSize / 2)
        attackButton.isUserInteractionEnabled = true
        attackButton.fillColor = .red
        attackButton.strokeColor = .white
        attackButton.position = CGPoint(
            x: buttonSize * 1.2,
            y: 0
        )
        
        addChild(attackButton)
    }
}

// MARK: JumpButton
final class JumpButton: SKShapeNode {
    // MARK: JumpButton + Overrides
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

// MARK: JumpButton + SceneObject
extension JumpButton: SceneObject {}

// MARK: AttackButton
final class AttackButton: SKShapeNode {
    // MARK: AttackButton + Overrides
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        levelScene?.player.attack()
    }
    
    func keyboardUp(presses: Set<UIPress>) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == "a" {
                levelScene?.player.attack()
            }
        }
    }
}

// MARK: AttackButton + SceneObject
extension AttackButton: SceneObject {
    func setup(scene: LevelScene) {
        
    }
}

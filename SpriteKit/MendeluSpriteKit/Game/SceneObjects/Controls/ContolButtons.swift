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
    
    private var center: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    }
    
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
        
        zPosition = Layer.controls
        anchorPoint = .zero
        
        let buttonSize: CGFloat = 72
        
        size = CGSize(
            width: 3 * buttonSize,
            height: 3 * buttonSize
        )
        position = CGPoint(
            x: scene.cameraObject.bottomRightCorner.x - size.width - 16,
            y: scene.cameraObject.bottomRightCorner.y + 16
        )
        
        jumpButton = JumpButton(imageNamed: Assets.Image.jumpButton)
        jumpButton.size = CGSize(size: buttonSize)
        jumpButton.isUserInteractionEnabled = true
        jumpButton.position = CGPoint(
            x: center.x,
            y: center.y - buttonSize
        )
        
        addChild(jumpButton)
        
        attackButton = AttackButton(imageNamed: Assets.Image.attackButton)
        attackButton.size = CGSize(size: buttonSize)
        attackButton.isUserInteractionEnabled = true
        attackButton.position = CGPoint(
            x: center.x + buttonSize,
            y: center.y
        )
        
        addChild(attackButton)
    }
}

// MARK: JumpButton
final class JumpButton: SKSpriteNode {
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
final class AttackButton: SKSpriteNode {
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
extension AttackButton: SceneObject {}

//
//  Joystick.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

import SpriteKit

final class Joystick: SKNode {
    // MARK: Properties
    private var backgroundNode: SKShapeNode?
    private var knobNode: SKShapeNode?
    private var pressedKeys = Set<String>()
    
    private var maxPosition: CGFloat {
        (backgroundNode?.frame.size.width ?? 0) / 2
    }
    
    private var size: CGFloat {
        (levelScene?.size.height ?? 0) * 0.13
    }
    
    /// Normalized value between -1 ... 1.
    private(set) var velocity: CGFloat = 0
    
    // MARK: Overrides
    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self).x
        
        let knobXPosition = touchLocation.clamped(to: -maxPosition ... maxPosition)
        
        updateKnobXPosition(knobXPosition: knobXPosition)
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        resetKnobNodePosition()
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        resetKnobNodePosition()
    }
}

// MARK: GameObject
extension Joystick: SceneObject {
    func setup(scene: LevelScene) {
        scene.cameraObject.addChild(self)

        isUserInteractionEnabled = true
        
        backgroundNode = SKShapeNode(circleOfRadius: size / 2)
        backgroundNode?.fillColor = .black
        backgroundNode?.strokeColor = .white
        backgroundNode?.alpha = 0.7
        
        addOptionalChild(backgroundNode)
        
        knobNode = SKShapeNode(circleOfRadius: (size * 0.8) / 2)
        knobNode?.fillColor = .white

        addOptionalChild(knobNode)
        
        zPosition = Layer.controls
        
        let bottomLeft = scene.cameraObject.bottomLeftCorner
        
        position = CGPoint(
            x: bottomLeft.x + 75,
            y: bottomLeft.y + 75
        )
    }
    
    func keyboardUp(presses: Set<UIPress>) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                pressedKeys.insert(UIKeyCommand.inputLeftArrow)
            }
            
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                pressedKeys.insert(UIKeyCommand.inputRightArrow)
            }
        }
        
        updateKnobXPositionKeyboardAfterPress()
    }
    
    func keyboardDown(presses: Set<UIPress>) {
        for press in presses {
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputLeftArrow {
                pressedKeys.remove(UIKeyCommand.inputLeftArrow)
            }
            
            if press.key?.charactersIgnoringModifiers == UIKeyCommand.inputRightArrow {
                pressedKeys.remove(UIKeyCommand.inputRightArrow)
            }
        }
        
        updateKnobXPositionKeyboardAfterPress()
    }
}

// MARK: Private API
private extension Joystick {
    func updateKnobXPositionKeyboardAfterPress() {
        var knobXPosition: CGFloat = 0
        
        for key in pressedKeys {
            if key == UIKeyCommand.inputLeftArrow {
                knobXPosition -= maxPosition
            }
            
            if key == UIKeyCommand.inputRightArrow {
                knobXPosition += maxPosition
            }
        }
        
        updateKnobXPosition(knobXPosition: knobXPosition)
    }
    
    func updateKnobXPosition(knobXPosition: CGFloat) {
        knobNode?.position = CGPoint(
            x: knobXPosition,
            y: 0
        )
        
        velocity = knobXPosition.normalize(
            min: -maxPosition,
            max: maxPosition,
            from: -1,
            to: 1
        )
    }
    
    func resetKnobNodePosition() {
        isUserInteractionEnabled = false
        
        velocity = 0
        
        let moveAction = SKAction.move(
            to: .zero,
            duration: 0.1
        )
        moveAction.timingMode = .easeInEaseOut
        
        knobNode?.run(moveAction) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
}

//
//  Joystick.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

import SpriteKit

final class Joystick: SKSpriteNode {
    // MARK: Properties
    private var backgroundNode: SKSpriteNode?
    private var knobNode: SKSpriteNode?
    private var pressedKeys = Set<String>()
    
    private var positionTresholds: EdgePositions {
        let halfOfJoystickWidth = joystickSize.width / 2
        
        return EdgePositions(
            max: defaultPosition.x + halfOfJoystickWidth,
            min: defaultPosition.x - halfOfJoystickWidth
        )
    }
    
    private var defaultPosition: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    }
    
    private let joystickSize = CGSize(size: 64)
    
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
        
        let knobXPosition = touchLocation.clamped(to: positionTresholds.min ... positionTresholds.max)
        
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
        size = CGSize(
            width: joystickSize.width + 2 * 72,
            height: joystickSize.height + 2 * 36
        )
        anchorPoint = .zero
        zPosition = Layer.controls
        
        scene.cameraObject.addChild(self)

        isUserInteractionEnabled = true
        
        let bottomLeft = scene.cameraObject.bottomLeftCorner
        
        position = CGPoint(
            x: bottomLeft.x,
            y: bottomLeft.y
        )
        
        backgroundNode = SKSpriteNode(imageNamed: Assets.Image.joystickBackground)
        backgroundNode?.size = joystickSize + 4
        backgroundNode?.zPosition = zPosition
        backgroundNode?.position = defaultPosition
        
        addOptionalChild(backgroundNode)
        
        knobNode = SKSpriteNode(imageNamed: Assets.Image.joystickKnob)
        knobNode?.position = defaultPosition
        knobNode?.zPosition = zPosition + 1
        knobNode?.size = joystickSize

        addOptionalChild(knobNode)
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

// MARK: EdgePositions
private extension Joystick {
    struct EdgePositions {
        let max: CGFloat
        let min: CGFloat
    }
}

// MARK: Private API
private extension Joystick {
    func updateKnobXPositionKeyboardAfterPress() {
        var knobXPosition = defaultPosition.x
        
        for key in pressedKeys {
            if key == UIKeyCommand.inputLeftArrow {
                knobXPosition = positionTresholds.min
            }
            
            if key == UIKeyCommand.inputRightArrow {
                knobXPosition = positionTresholds.max
            }
        }
        
        updateKnobXPosition(knobXPosition: knobXPosition)
    }
    
    func updateKnobXPosition(knobXPosition: CGFloat) {
        knobNode?.position = CGPoint(
            x: knobXPosition,
            y: defaultPosition.y
        )
        
        velocity = knobXPosition.normalize(
            min: positionTresholds.min,
            max: positionTresholds.max,
            from: -1,
            to: 1
        )
    }
    
    func resetKnobNodePosition() {
        isUserInteractionEnabled = false
        
        velocity = 0
        
        let moveAction = SKAction.move(
            to: defaultPosition,
            duration: 0.1
        )
        moveAction.timingMode = .easeInEaseOut
        
        knobNode?.run(moveAction) { [weak self] in
            self?.isUserInteractionEnabled = true
        }
    }
}

//
//  Joystick.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

import SpriteKit

final class Joystick: SKSpriteNode {
    // MARK: Properties
    /// Joystick background, this one will not move
    private var backgroundNode: SKSpriteNode?
    /// Moving part of the joystick
    private var knobNode: SKSpriteNode?
    
    private let joystickSize = CGSize(size: 64)
    
    /// Default posiotion for joystick itself and the background of our joystick
    private var defaultPosition: CGPoint {
        CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )
    }
    
    /// -1 moving to left
    /// 0 standing
    /// 1 right
    private(set) var velocity: CGFloat = .zero
    
    private var positionThresholds: EdgePositions {
        let halfOfJoystickWidth = joystickSize.width / 2
        
        return EdgePositions(
            max: defaultPosition.x + halfOfJoystickWidth,
            min: defaultPosition.x - halfOfJoystickWidth
        )
    }
    
    // MARK: Overrides
    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        // TODO: Update knob when touches were moved
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self).x
        
        let knobXPosition = touchLocation.clamped(to: positionThresholds.min ... positionThresholds.max)
        
        updateKnobXPosition(knobXPosition: knobXPosition)
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        // TODO: Reset knob position upon touches ended
        resetKnobNodePosition()
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        // TODO: Reset knob position upon touches cancel
        resetKnobNodePosition()
    }
}

// MARK: GameObject
extension Joystick: SceneObject {
    func setup(scene: LevelScene) {
        // TODO: Setup Joystick
        // setup size
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
        knobNode?.size = joystickSize
        knobNode?.zPosition = zPosition + 1
        knobNode?.position = defaultPosition

        addOptionalChild(knobNode)
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
    func updateKnobXPosition(knobXPosition: CGFloat) {
        // TODO: Implement updateKnobXPosition
        knobNode?.position = CGPoint(
            x: knobXPosition,
            y: defaultPosition.y
        )
        
        velocity = knobXPosition.normalize(
            min: positionThresholds.min,
            max: positionThresholds.max,
            from: -1,
            to: 1
        )
        
        print(velocity)
    }
    
    func resetKnobNodePosition() {
        // TODO: Implement resetKnobNodePosition
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

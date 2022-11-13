//
//  Joystick.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

import SpriteKit

final class Joystick: SKSpriteNode {
    // MARK: Properties
    
    // MARK: Overrides
    override func touchesMoved(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        // TODO: Update knob when touches were moved
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        // TODO: Reset knob position upon touches ended
    }

    override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        // TODO: Reset knob position upon touches cancel
    }
}

// MARK: GameObject
extension Joystick: SceneObject {
    func setup(scene: LevelScene) {
        // TODO: Setup Joystick
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
    }
    
    func resetKnobNodePosition() {
        // TODO: Implement resetKnobNodePosition
    }
}

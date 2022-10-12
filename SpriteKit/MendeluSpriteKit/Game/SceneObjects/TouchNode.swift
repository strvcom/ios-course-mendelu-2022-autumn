//
//  TouchNode.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 12.10.2022.
//

import SpriteKit

class TouchNode: SKSpriteNode {

    var tapAction: (() -> Void)?
    override var isUserInteractionEnabled: Bool {
        set { }
        get { true }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.2),
            SKAction.fadeAlpha(to: 1, duration: 0.1)
        ]))
        tapAction?()
    }
}

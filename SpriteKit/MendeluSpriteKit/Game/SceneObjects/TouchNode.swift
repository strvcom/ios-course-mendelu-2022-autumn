//
//  TouchNode.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 12.10.2022.
//

import SpriteKit

final class TouchNode: SKSpriteNode {

    // MARK: Properties
    var tapAction: (() -> Void)?
    override var isUserInteractionEnabled: Bool {
        set { }
        get { true }
    }

    // MARK: Public
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        run(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.2),
            SKAction.fadeAlpha(to: 1, duration: 0.1)
        ]))

        tapAction?()
    }
}

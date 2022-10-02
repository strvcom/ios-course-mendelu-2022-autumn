//
//  HurtBox.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import SpriteKit

final class HurtBox: SKSpriteNode {
    convenience init(
        size: CGSize,
        position: CGPoint = .zero
    ) {
        self.init(
            texture: nil,
            color: Environment.showHitboxesAndHurtBoxes
                ? .red
                : .clear,
            size: size
        )
        
        self.position = position
    }
}

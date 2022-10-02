//
//  HitBox.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 02.10.2022.
//

import SpriteKit

final class HitBox: SKSpriteNode {
    convenience init(
        size: CGSize,
        position: CGPoint = .zero
    ) {
        self.init(
            texture: nil,
            color: Environment.showHitboxesAndHurtBoxes
                ? .blue
                : .clear,
            size: size
        )
        
        self.position = position
    }
}

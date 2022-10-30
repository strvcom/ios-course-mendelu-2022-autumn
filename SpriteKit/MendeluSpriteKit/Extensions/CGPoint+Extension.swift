//
//  CGPoint+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 01.10.2022.
//

import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        sqrt(pow((point.y - y), 2) + pow((point.x - x), 2))
    }
    
    init(position: CGFloat) {
        self.init(
            x: position,
            y: position
        )
    }
}

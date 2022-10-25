//
//  CGSize+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.10.2022.
//

import CoreGraphics

extension CGSize {
    static func + (left: CGSize, right: CGFloat) -> CGSize {
        CGSize(
            width: left.width + right,
            height: left.height + right
        )
    }
    
    init(size: CGFloat) {
        self.init(
            width: size,
            height: size
        )
    }
}

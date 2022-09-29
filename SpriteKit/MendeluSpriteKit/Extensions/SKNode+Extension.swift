//
//  SKNode+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 26.09.2022.
//

import SpriteKit

extension SKNode {
    func addOptionalChild(_ child: SKNode?) {
        guard let child = child else {
            return
        }
        
        addChild(child)
    }
}

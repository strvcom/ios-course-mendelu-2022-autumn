//
//  Layer.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import UIKit

enum Layer {
    // MARK: Level 0
    static let background1: CGFloat = 0
    static let background2: CGFloat = 1
    static let background3: CGFloat = 2
    static let background4: CGFloat = 3
    // For some reason, we need to set values for colored sprites to 0
    static let hitbox: CGFloat = 0
    static let hurtBox: CGFloat = 0
    
    // MARK: Level 1
    static let scenery: CGFloat = 10
    static let tiles: CGFloat = 11
    static let shootingPumpkin: CGFloat = 11
    static let fountain: CGFloat = 12
    static let player: CGFloat = 12
    static let zombie: CGFloat = 12
    static let projectile: CGFloat = 12
    
    // MARK: Controls
    static let controls: CGFloat = 20
}

//
//  Layer.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import UIKit

/// Definition of the Z position of the objects, which means depth of the objects in scene.
/// `SKNodes` with higher value are going to overlap the nodes with smaller one.
enum Layer {
    // MARK: Level 0
    static let background1: CGFloat = 0
    static let background2: CGFloat = 1
    static let background3: CGFloat = 2
    static let background4: CGFloat = 3
    // For some reason, we need to set values for colored sprites to 0
    static let hitbox: CGFloat = 0
    static let hurtBox: CGFloat = 0
    
    // MARK: Level
    static let scenery: CGFloat = 10
    static let tiles: CGFloat = 11
    static let shootingPumpkin: CGFloat = 11
    static let door: CGFloat = 11
    static let fountain: CGFloat = 10
    // Some of the objects can have the same value, because they won't overlap
    // due to having physics body (they will colide).
    static let player: CGFloat = 12
    static let zombie: CGFloat = 12
    static let projectile: CGFloat = 12
    
    // MARK: Controls
    /// Controls needs to be always visible to player, hence they have the biggest value.
    static let controls: CGFloat = 20
}

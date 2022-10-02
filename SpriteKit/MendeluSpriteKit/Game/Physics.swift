//
//  Physics.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

enum Physics {
    static let everyBitSet: UInt32 = 0b1111_1111_1111_1111_1111_1111_1111_1111
}

// MARK: CategoryBitMask
extension Physics {
    enum CategoryBitMask {
        static let groundTile: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0001
        static let boundary: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0010
        static let player: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0100
        static let zombie: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_1000
        static let projectile: UInt32 = 0b0000_0000_0000_0000_0000_0000_0001_0000
    }
}

// MARK: CollisionBitMask
extension Physics {
    enum CollisionBitMask {
        static let projectile = Physics.everyBitSet
        static let player = Physics.CategoryBitMask.boundary |
            Physics.CategoryBitMask.zombie |
            Physics.CategoryBitMask.groundTile
        static let zombie = Physics.CategoryBitMask.player
            | Physics.CategoryBitMask.groundTile
            | Physics.CategoryBitMask.boundary
        static let groundTile = Physics.CategoryBitMask.player |
            Physics.CategoryBitMask.zombie
        static let boundary = Physics.CategoryBitMask.player |
            Physics.CategoryBitMask.zombie
    }
}

// MARK: ContactTestBitMask
extension Physics {
    enum ContactTestBitMask {
        static let player = Physics.CategoryBitMask.groundTile
        static let projectile = Physics.everyBitSet
    }
}

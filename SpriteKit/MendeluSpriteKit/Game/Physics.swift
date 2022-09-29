//
//  Physics.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

enum Physics {}

// MARK: CategoryBitMask
extension Physics {
    enum CategoryBitMask {
        /// Bitmask with value of `0000 0000 0000 0000 0000 0000 0000 0001`.
        static let groundTile: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0001
        /// Bitmask with value of `0000 0000 0000 0000 0000 0000 0000 0010`.
        static let player: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0010
        
        static let pain: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0000
    }
}

extension Physics {
    enum CollisionBitMask {
        
    }
}

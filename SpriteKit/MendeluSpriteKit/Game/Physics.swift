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
        static let boundary: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0010
        /// Bitmask with value of `0000 0000 0000 0000 0000 0000 0000 0100`.
        static let player: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_0100
        /// Bitmask with value of `0000 0000 0000 0000 0000 0000 0000 1000`.
        static let zombie: UInt32 = 0b0000_0000_0000_0000_0000_0000_0000_1000
    }
}

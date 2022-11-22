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
    /// Defines what physics category the body belongs to.
    /// Every physics body in a scene can be assigned to up to 32 different categories,
    /// each corresponding to a bit in the bit mask. You define the mask values
    /// used in your game. In conjunction with the `collisionBitMask` and `contactTestBitMask`
    /// properties, you define which physics bodies interact with each other and when your
    /// game is notified of these interactions.
    // TODO: Implement CategoryBitMask
    enum CategoryBitMask {
        static let groundTile: UInt32 = 0b10
        static let boundary: UInt32 = 0
        static let player: UInt32 = 0b1
        static let zombie: UInt32 = 0
        static let projectile: UInt32 = 0
        static let door: UInt32 = 0
    }
}

// MARK: CollisionBitMask
extension Physics {
    /// A mask that defines which categories of physics bodies can collide with this physics body.
    /// When two physics bodies contact each other, a collision may occur.
    /// This body’s collision mask is compared to the other body’s category
    /// mask by performing a logical AND operation. If the result is a nonzero value,
    /// this body is affected by the collision.
    // TODO: Implement CategoryBitMask
    enum CollisionBitMask {
        static let projectile: UInt32 = 0
        static let player: UInt32 = Physics.CategoryBitMask.groundTile
        static let zombie: UInt32 = 0
        static let groundTile: UInt32 = Physics.CategoryBitMask.player
        static let boundary: UInt32 = 0
    }
}

// MARK: ContactTestBitMask
extension Physics {
    /// A mask that defines which categories of physics bodies cause intersection
    /// notifications with this physics body. When two bodies share the same space,
    /// each body’s category mask is tested against the other body’s contact mask
    /// by performing a logical AND operation. If either comparison results
    /// in a nonzero value, an SKPhysicsContact object is created
    /// and passed to the physics world’s delegate.
    // TODO: Implement ContactTestBitMask
    enum ContactTestBitMask {
        static let player: UInt32 = 0
        static let projectile: UInt32 = 0
    }
}

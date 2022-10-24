//
//  PlayerObservingObject.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 11.10.2022.
//

import SpriteKit

protocol PlayerObservingObject: SceneObject, SKNode { }

extension PlayerObservingObject {

    var playerPosition: CGPoint {
        levelScene?.player.position ?? .zero
    }

    var distanceToPlayer: CGFloat {
        playerPosition.distance(to: position)
    }
}

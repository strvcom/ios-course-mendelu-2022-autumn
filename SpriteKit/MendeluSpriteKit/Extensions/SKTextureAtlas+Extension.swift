//
//  SKTextureAtlas+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 19.09.2022.
//

import SpriteKit

extension SKTextureAtlas {
    var textures: [SKTexture] {
        textureNames
            .sorted()
            .map { textureNamed($0) }
    }
}

//
//  WelcomeScreen.swift
//  MendeluSpriteKit
//
//  Created by Raul Batista on 08.11.2022.
//

import Foundation
import SpriteKit

final class WelcomeScreen: SKScene {
    // MARK: Properties
    private var newGameButton: TouchNode?
    
    var newGameButtonTapped: (() -> Void)?
}

// MARK: Public API
extension WelcomeScreen {
    override func didMove(to view: SKView) {
        newGameButton = children.first(where: { $0 is TouchNode }) as? TouchNode
        newGameButton?.tapAction = { [weak self] in
            self?.newGameButtonTapped?()
        }
    }
    
    func setBackgroundImage(_ image: UIImage) {
        let background = SKSpriteNode(texture: SKTexture(image: image))
        let aspectRatio = image.size.height / image.size.width
        let backgroundSize = CGSize(width: size.width, height: size.width * aspectRatio)

        background.size = backgroundSize
        background.zPosition = -1
        background.alpha = 1

        addChild(background)
    }
}

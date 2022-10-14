//
//  LevelFinishedScene.swift
//  MendeluSpriteKit
//
//  Created by Martina Stremenova on 12.10.2022.
//

import SpriteKit


final class LevelFinishedScene: SKScene {
    // MARK: Properties
    private var playAgainButton: TouchNode?

    var newGameButtonTapped: (() -> Void)?
}

// MARK: Public API
extension LevelFinishedScene {
    override func didMove(to view: SKView) {
        backgroundColor = .black

        playAgainButton = children.first(where: { $0 is TouchNode }) as? TouchNode
        playAgainButton?.tapAction = { [weak self] in
            self?.newGameButtonTapped?()
        }
    }

    func setBackgroundImage(_ image: UIImage) {
        let background = SKSpriteNode(texture: SKTexture(image: image))

        background.size = size
        background.zPosition = -1
        background.alpha = 0.3

        addChild(background)
    }
}

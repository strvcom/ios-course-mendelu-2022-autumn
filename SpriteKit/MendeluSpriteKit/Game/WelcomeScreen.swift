//
//  WelcomeScreen.swift
//  MendeluSpriteKit
//
//  Created by Raul Batista on 08.11.2022.
//

import Foundation
import SpriteKit

protocol WelcomeScreenDelegate: AnyObject {
    func newGameButtonTapped()
}

final class WelcomeScreen: SKScene {
    // MARK: Properties
    private var newGameButton: TouchNode?
    
    weak var welcomeScreenDelegate: WelcomeScreenDelegate?
}

// MARK: Public API
extension WelcomeScreen {
    override func didMove(to view: SKView) {
        newGameButton = children.first(where: { $0 is TouchNode }) as? TouchNode
        newGameButton?.tapAction = { [welcomeScreenDelegate] in
            welcomeScreenDelegate?.newGameButtonTapped()
        }
        
        if let welcomeBackground = UIImage(named: Assets.Image.welcomeBackground) {
            setBackgroundImage(welcomeBackground)
        }
    }
    
    private func setBackgroundImage(_ image: UIImage) {
        let background = SKSpriteNode(texture: SKTexture(image: image))
        let aspectRatio = image.size.height / image.size.width
        let backgroundSize = CGSize(width: size.width, height: size.width * aspectRatio)

        background.size = backgroundSize
        background.zPosition = -1
        background.alpha = 1

        addChild(background)
    }
}

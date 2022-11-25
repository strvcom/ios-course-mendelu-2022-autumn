//
//  EmojiLoadingScene.swift
//  RickAndMorty
//
//  Created by Matej Molnár on 25.11.2022.
//

import SpriteKit

class EmojiLoadingScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .clear
        
        setupEmojis([
            Assets.Image.Emojis.rick,
            Assets.Image.Emojis.morty,
            Assets.Image.Emojis.meeseeks,
            Assets.Image.Emojis.pickle
        ])
        startAnimation()
    }
    
    private func setupEmojis(_ imageNames: [String]) {
        let distance = size.width / CGFloat(imageNames.count)

        for (index, name) in imageNames.enumerated() {
            let node = SKSpriteNode(imageNamed: name)
            
            node.size = CGSize(width: distance*0.7, height: distance*0.7)
            node.position.y = size.height / 2
            node.position.x = distance * (CGFloat(index) + 0.5)
            
            addChild(node)
        }
    }
    
    private func startAnimation() {
        for (index, node) in children.enumerated() {
            node.run(
                .sequence([
                    .wait(forDuration: Double(index) * 0.2),
                    .repeatForever(
                        .sequence([
                            .group([
                                .rotate(byAngle: .pi * 2, duration: 0.6),
                                .sequence([
                                    .scale(to: 1.5, duration: 0.3),
                                    .scale(to: 1, duration: 0.3)
                                ])
                            ]),
                            .wait(forDuration: 0.5)
                        ])
                    )
                ])
            )
        }
    }
}

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
                    /// Because of this wait actions each node starts animating 0.2 seconds after the previous one.
                    .wait(forDuration: Double(index) * 0.2),
                    /// The animation is repeating.
                    .repeatForever(
                        /// Actions in a sequence are executed one after another.
                        .sequence([
                            /// Actions in a group are executed simultaneously.
                            .group([
                                /// Rotate the node 360 degrees.
                                .rotate(byAngle: .pi * 2, duration: 0.6),
                                /// Scale the node by 50% and then back.
                                .sequence([
                                    .scale(to: 1.5, duration: 0.3),
                                    .scale(to: 1, duration: 0.3)
                                ])
                            ]),
                            /// After the rotation + scale animation is done wait for 0.6 before repeating it, otherwise the animation would look chaotic.
                            .wait(forDuration: 0.6)
                        ])
                    )
                ])
            )
        }
    }
}

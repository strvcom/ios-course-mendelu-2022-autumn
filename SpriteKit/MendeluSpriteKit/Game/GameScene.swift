//
//  GameScene.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import SpriteKit

final class GameScene: SKScene {
    // MARK: Properties
    private let controlsHidden = false
    
    var allGameObjects: [GameObject] {
        [
//            cameraObject,
            background
//            ground,
//            player,
//            joystick,
//            jumpButton
        ]
    }
    
    private(set) lazy var cameraObject = Camera()
    private(set) var background: Background!
    private(set) lazy var player = Player()
    private(set) lazy var joystick = Joystick()
    private(set) lazy var jumpButton = JumpButton()
    
    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        background = Background()
        
        children.forEach { print("Pain", $0, $0.name) }
        
        allGameObjects.forEach { $0.setup(gameScene: self) }

//        if controlsHidden {
//            joystick.alpha = 0
//            jumpButton.alpha = 0
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        allGameObjects.forEach { $0.update(currentTime) }
    }
}

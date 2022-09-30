//
//  GameScene.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import SpriteKit

final class GameScene: SKScene {
    // MARK: Properties
    var allGameObjects: [GameObject] {
        [
            cameraObject,
            background,
            ground,
            player,
            joystick,
            jumpButton
        ]
    }
    
    private(set) var cameraObject: Camera!
    private(set) var background: Background!
    private(set) var ground: Ground!
    private(set) var player: Player!
    private(set) var joystick: Joystick!
    private(set) var jumpButton: JumpButton!
    
    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        scaleMode = .aspectFill
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        cameraObject = Camera()
        background = Background()
        ground = Ground(ground: childNode(withName: Self.groundTileNodeName) as! SKTileMapNode)
        player = Player()
        joystick = Joystick()
        jumpButton = JumpButton()
        
        allGameObjects.forEach { $0.setup(gameScene: self) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        allGameObjects.forEach { $0.update(currentTime) }
    }
}

// MARK: Constants
extension GameScene {
    static let groundTileNodeName = "Ground"
}

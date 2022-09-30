//
//  LevelScene.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import SpriteKit

final class LevelScene: SKScene {
    // MARK: Properties
    var allSceneObjects: [SceneObject] {
        [
            cameraObject,
            background,
            level,
            player,
            joystick,
            jumpButton
        ]
    }
    
    private(set) var cameraObject: Camera!
    private(set) var background: Background!
    private(set) var level: Level!
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
        level = Level(ground: childNode(withName: "Ground") as! SKTileMapNode)
        player = Player()
        joystick = Joystick()
        jumpButton = JumpButton()
        
        allSceneObjects.forEach { $0.setup(scene: self) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        allSceneObjects.forEach { $0.update(currentTime) }
    }
}

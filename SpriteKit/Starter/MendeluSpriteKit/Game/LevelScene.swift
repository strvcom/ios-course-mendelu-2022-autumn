//
//  LevelScene.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import SpriteKit

// TODO: Implement LevelSceneDelegate
protocol LevelSceneDelegate: AnyObject {}

final class LevelScene: SKScene {
    // MARK: Properties
    weak var levelSceneDelegate: LevelSceneDelegate?
    
    var allSceneObjects: [SceneObject] {
        [
            cameraObject,
            level,
            player,
            joystick
        ]
    }
    // TODO: Add Camera
    private(set) var cameraObject: Camera!
    // TODO: Add Background
    
    // TODO: Add Level
    private(set) var level: Level!
    // TODO: Add Player
    private(set) var player: Player!
    // TODO: Add Joystick
    private(set) var joystick: Joystick!
    // TODO: Add ControlButtons
    
    // TODO: Add PlayerLifes
    
    // TODO: Add Zombies
    
    // TODO: Add Others
    
    // TODO: Add Scene objects properties

    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        // TODO: Setup scaling
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        cameraObject = Camera()
        joystick = Joystick()

        for child in children {
            switch child {
            case let map as SKTileMapNode:
                level = Level(ground: map)
            case let player as Player:
                self.player = player
            // TODO: Add other pending objects
            default:
                break
            }
        }
        
        // MARK: Set physics contact delegate
        
        // MARK: Initialize Scene objects
        allSceneObjects.forEach { $0.setup(scene: self) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // TODO: Update Scene objects
        allSceneObjects.forEach { $0.update(currentTime) }
    }
}

// TODO: Implement SKPhysicsContactDelegate
extension LevelScene {}

// MARK: Public API
extension LevelScene {
    func zombieDied(zombie: Zombie) {
        // TODO: Implement zombieDied
    }

    func playerEnteredDoor() {
        // TODO: Implement playerEnteredDoor
    }

    func playerDied() {
        // TODO: Implement playerDied
    }
}

// MARK: Private API
private extension LevelScene {
    /// Creates screenshot from current view and returns it as `UIImage`.
    func makeScreenshot() -> UIImage? {
        let snapshotView = view?.snapshotView(afterScreenUpdates: true)
        let bounds = UIScreen.main.bounds

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        snapshotView?.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return screenshotImage
    }
}

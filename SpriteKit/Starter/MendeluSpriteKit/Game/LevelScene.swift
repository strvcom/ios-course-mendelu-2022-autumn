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
        []
    }
    // TODO: Add Camera
    
    // TODO: Add Background
    
    // TODO: Add Level
    
    // TODO: Add Player

    // TODO: Add Joystick
    
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
        
        // MARK: Set physics contact delegate
        
        // MARK: Initialize Scene objects
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // TODO: Update Scene objects
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

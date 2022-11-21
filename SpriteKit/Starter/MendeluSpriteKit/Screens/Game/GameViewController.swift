//
//  GameViewController.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import UIKit
import SpriteKit

final class GameViewController: UIViewController {
    // MARK: Properties
    private var skView: SKView {
        view as! SKView
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override var prefersStatusBarHidden: Bool {
        true
    }
    
    // MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        skView.showsFPS = Environment.sceneInDebugMode
        skView.showsNodeCount = Environment.sceneInDebugMode
        skView.ignoresSiblingOrder = true
        skView.preferredFramesPerSecond = 30
        skView.showsPhysics = Environment.sceneInDebugMode
        skView.isMultipleTouchEnabled = true
        
        startGame()
    }
    
    // TODO: Implement presses for debug purposes
    
    func startGame() {
        // TODO: Show Level scene
        guard let scene = SKScene(fileNamed: Assets.Scenes.level2) else {
            return
        }
        
        skView.presentScene(scene)
    }

    func showLevelFinishedScene(
        sceneFileName: String,
        backgroundImage: UIImage
    ) {
        // TODO: Implement level scene finish
    }
}

// MARK: LevelSceneDelegate
extension GameViewController: LevelSceneDelegate {}

// MARK: WelcomeScreenDelegate
extension GameViewController: WelcomeScreenDelegate {
    func welcomeScreenNewGameButtonTapped() {
        startGame()
    }
}

extension GameViewController: LevelFinishedSceneDelegate {
    func levelFinishedSceneNewGameButtonTapped() {
        startGame()
    }
}

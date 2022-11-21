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
    
    /// React to presses began and passes them to `LevelScene`. We found out, when you
    /// override methods in `SKNode`, it doesn't always work.
    override func pressesBegan(
        _ presses: Set<UIPress>,
        with event: UIPressesEvent?
    ) {
        super.pressesBegan(
            presses,
            with: event
        )
        
        guard let scene = skView.scene as? LevelScene else {
            return
        }
        
        for gameObject in scene.allSceneObjects {
            gameObject.keyboardUp(presses: presses)
        }
    }
    
    /// React to presses ended and passes them to `LevelScene`. We found out, when you
    /// override methods in `SKNode`, it doesn't always work.
    override func pressesEnded(
        _ presses: Set<UIPress>,
        with event: UIPressesEvent?
    ) {
        super.pressesEnded(
            presses,
            with: event
        )
        
        guard let scene = skView.scene as? LevelScene else {
            return
        }
        
        for gameObject in scene.allSceneObjects {
            gameObject.keyboardDown(presses: presses)
        }
    }
    
    func startGame() {
        guard let scene = SKScene(fileNamed: Assets.Scenes.level1) else {
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

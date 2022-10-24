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
        
        startGame()
    }
    
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
        guard let scene = LevelScene(fileNamed: Assets.Scenes.level1) else {
            return
        }
        scene.completionDelegate = self

        let transition = SKTransition.crossFade(withDuration: 0.6)
        skView.presentScene(scene, transition: transition)
    }

    func showLevelFinishedScene(sceneFileName: String, backgroundImage: UIImage) {
        guard let scene = LevelFinishedScene(fileNamed: sceneFileName) else {
            return
        }

        scene.setBackgroundImage(backgroundImage)
        scene.newGameButtonTapped = { [weak self] in
            self?.startGame()
        }

        scene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 1)
        skView.presentScene(scene, transition: transition)
    }
}

// MARK: LevelCompletionDelegate
extension GameViewController: LevelCompletionDelegate {
    func levelCompleted(sceneImage: UIImage) {
        showLevelFinishedScene(sceneFileName: Assets.Scenes.levelCompleted, backgroundImage: sceneImage)
    }
    
    func levelFailed(sceneImage: UIImage) {
        showLevelFinishedScene(sceneFileName: Assets.Scenes.gameOver, backgroundImage: sceneImage)
    }
}

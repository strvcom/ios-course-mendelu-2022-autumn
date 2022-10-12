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
        
        guard let scene = LevelScene(fileNamed: Assets.Scenes.level1) else {
            return
        }
        scene.completionDelegate = self

        skView.presentScene(scene)
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
}

extension GameViewController: LevelCompletionDelegate {
    func levelCompleted(sceneImage: UIImage) {
        guard let scene = LevelFinishedScene(fileNamed: Assets.Scenes.levelCompleted) else {
            return
        }
        scene.setBackgroundImage(sceneImage)
        scene.scaleMode = .aspectFill
        let transition = SKTransition.crossFade(withDuration: 0.8)
        skView.presentScene(scene, transition: transition)
    }
    
    func levelFailed(sceneImage: UIImage) {
        guard let scene = SKScene(fileNamed: Assets.Scenes.gameOver) else {
            return
        }
        scene.scaleMode = .resizeFill
        let transition = SKTransition.crossFade(withDuration: 0.6)
        skView.presentScene(scene, transition: transition)
    }
}

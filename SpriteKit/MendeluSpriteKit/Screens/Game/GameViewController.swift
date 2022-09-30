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
        
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.preferredFramesPerSecond = 30
        skView.showsPhysics = true
        
        guard let scene = GameScene(fileNamed: Assets.Scenes.level1) else {
            return
        }
            
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
        
        guard let scene = skView.scene as? GameScene else {
            return
        }
        
        for gameObject in scene.allGameObjects {
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
        
        guard let scene = skView.scene as? GameScene else {
            return
        }
        
        for gameObject in scene.allGameObjects {
            gameObject.keyboardDown(presses: presses)
        }
    }
}

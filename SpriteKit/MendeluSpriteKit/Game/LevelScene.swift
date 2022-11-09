//
//  LevelScene.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 18.09.2022.
//

import SpriteKit

protocol LevelCompletionDelegate: AnyObject {
    func levelCompleted(sceneImage: UIImage)
    func levelFailed(sceneImage: UIImage)
}

final class LevelScene: SKScene {
    // MARK: Properties
    private let controlsHidden = true

    weak var completionDelegate: LevelCompletionDelegate?

    var allSceneObjects: [SceneObject] {
        [
            cameraObject,
            background,
            level,
            player,
            joystick,
            controlButtons,
            playerLifes
        ]
        + zombies
        + others
    }

    private(set) var cameraObject: Camera!
    private(set) var background: Background!
    private(set) var level: Level!
    private(set) var player: Player!
    private(set) var joystick: Joystick!
    private(set) var controlButtons: ControlButtons!
    private(set) var playerLifes: PlayerLifes!
    private(set) var zombies = [Zombie]()
    private(set) var others = [SceneObject]()
    /// Indicates whether player is eligible to complete the level succesfully
    /// and is based on conditions player must comply to to succeed.
    /// For example player must kill all Zombies and only then is eligible to complete the level.
    var levelCanBeCompleted: Bool { zombies.isEmpty }

    // MARK: Overrides
    override func willMove(from view: SKView) {
        super.willMove(from: view)

        scaleMode = .aspectFill
    }

    override func sceneDidLoad() {
        physicsWorld.contactDelegate = self

        cameraObject = Camera()

        background = Background()

        joystick = Joystick()

        controlButtons = ControlButtons()

        playerLifes = PlayerLifes()

        for child in children {
            switch child {
            case let zombie as Zombie:
                zombies.append(zombie)
            case let map as SKTileMapNode:
                level = Level(ground: map)
            case let player as Player:
                self.player = player
            case let other as SceneObject:
                others.append(other)
            default:
                break
            }
        }

        allSceneObjects.forEach { $0.setup(scene: self) }
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        allSceneObjects.forEach { $0.update(currentTime) }
    }
}

// MARK: SKPhysicsContactDelegate
extension LevelScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        allSceneObjects.forEach { $0.handleContactStart(contact) }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        allSceneObjects.forEach { $0.handleContactEnd(contact) }
    }
}

// MARK: Public API
extension LevelScene {
    func zombieDied(zombie: Zombie) {
        guard let index = zombies.firstIndex(where: { $0 === zombie }) else {
            return
        }
        zombies.remove(at: index)
    }

    func playerEnteredDoor() {
        player.isPaused = true
        player.alpha = 0

        guard let levelSceneScreenshot = makeScreenshot() else { return }

        completionDelegate?.levelCompleted(sceneImage: levelSceneScreenshot)
    }

    func playerDied() {
        guard let levelSceneScreenshot = makeScreenshot() else { return }

        completionDelegate?.levelFailed(sceneImage: levelSceneScreenshot)
    }
}


private extension LevelScene {
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

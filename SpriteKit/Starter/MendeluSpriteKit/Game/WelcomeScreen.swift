//
//  WelcomeScreen.swift
//  MendeluSpriteKit
//
//  Created by Raul Batista on 08.11.2022.
//

import Foundation
import SpriteKit

protocol WelcomeScreenDelegate: AnyObject {
    func welcomeScreenNewGameButtonTapped()
}

final class WelcomeScreen: SKScene {
    // MARK: Properties
    weak var welcomeScreenDelegate: WelcomeScreenDelegate?
}

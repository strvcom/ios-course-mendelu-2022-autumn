//
//  XCUIApplication+Scenes.swift
//  SignMeAppUITests
//
//  Created by Martin Vidovic on 03.10.2022.
//

import XCTest

extension XCUIApplication {
    var signInScene: SignInScene {
        SignInScene(app: self)
    }
}


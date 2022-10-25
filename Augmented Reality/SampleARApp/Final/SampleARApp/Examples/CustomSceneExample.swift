//
//  CustomSceneExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 14.10.2022.
//

import Foundation
import ARKit

final class CustomSceneExample: ARViewController {
    override func viewDidLoad() {
        // The initialization can fail if the scene file does not exist.
        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        sceneView.scene = scene
        super.viewDidLoad()
    }
}

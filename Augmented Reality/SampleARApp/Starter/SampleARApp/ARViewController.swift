//
//  ARViewController.swift
//  SampleARApp
//
//  Created by Tony Ngo on 02.09.2022.
//

import ARKit
import Foundation
import UIKit
import RealityKit

class ARViewController: UIViewController {
    let sceneView = ARSCNView()

    var configuration: ARConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 1. Create Configuration


        // 2. Run the configuration
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 1. Pause the session.
    }
}

extension ARViewController {
    var session: ARSession {
        sceneView.session
    }

    var scene: SCNScene {
        sceneView.scene
    }

    func addNode(_ node: SCNNode, to parentNode: SCNNode? = nil) {
        // Implement this method
    }

    func removeNode(_ node: SCNNode) {
        // Implement this method
    }

    func removeAllNodes() {
        // Implement this method
    }
}

private extension ARViewController {
    func initialSetup() {
        // Enable lightning
        sceneView.autoenablesDefaultLighting = true

        view.addSubview(sceneView)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

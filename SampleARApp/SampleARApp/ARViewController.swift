//
//  ARViewController.swift
//  SampleARApp
//
//  Created by Tony Ngo on 02.09.2022.
//

import ARKit
import Foundation
import UIKit

class ARViewController: UIViewController {
    let sceneView = ARSCNView()

    weak var sceneDelegate: ARSCNViewDelegate?

    weak var sessionDelegate: ARSessionDelegate?

    var configuration: ARConfiguration?

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the scene view's session
        let configuration: ARConfiguration = self.configuration ?? ARWorldTrackingConfiguration()
        session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the scene view's session
        session.pause()
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
        let parentNode = parentNode ?? scene.rootNode
        parentNode.addChildNode(node)
    }

    func removeNode(_ node: SCNNode) {
        scene.rootNode.enumerateChildNodes { childNode, _ in
            if childNode == node {
                childNode.removeFromParentNode()
            }
        }
    }

    func removeAllNodes() {
        sceneView.scene.rootNode.childNodes.forEach {
            $0.removeFromParentNode()
        }
    }
}

private extension ARViewController {
    func initialSetup() {
        // Set scene view's delegate
        sceneView.delegate = sceneDelegate

        // Set scene session's delegate
        sceneView.session.delegate = sessionDelegate

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

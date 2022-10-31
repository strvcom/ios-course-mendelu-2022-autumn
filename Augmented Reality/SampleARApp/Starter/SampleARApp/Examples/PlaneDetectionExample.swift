//
//  PlaneDetectionExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 06.09.2022.
//

import Foundation
import ARKit

final class PlaneDetectionExample: ARViewController {
    private var isDetecting: Bool = false

    private lazy var detectButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50
        button.clipsToBounds = true
        button.backgroundColor = .red.withAlphaComponent(0.7)
        return button
    }()

    override func viewDidLoad() {
        setupPlaneDetection()
        super.viewDidLoad()
        setupDetectButton()
    }
}

// MARK: - ARSCNViewDelegate

extension PlaneDetectionExample: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Create a mesh to visualize the estimated shape of the plane.

        // 1. Check for ARPlaneAchors only, using guard let.


        // 2. Create ARSCNPlaneGeometry.


        // 3. Create a node to visualize the plane's bounding rectangle.


        // 4. Name it for future usage.


        // 5. Set colors to differentiate planes.


        // 6. Add the created node as a child node of the added node.


        // 7. Reshape the created node's geometry to match the anchor's mesh.

    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1. Check for ARPlaneAchors only, using guard let.


        // 2. Check if the updated node is the one we added from the delegate method above.


        // 3. Get its geometry.


        // 4. Update ARSCNPlaneGeometry to the anchor's new estimated shape.

    }
}

private extension PlaneDetectionExample {
    func setupPlaneDetection() {
        // 1. Create configuration that supports plane detection


        // 2. Assign scene view's delegate to self to respond to renderer's actions


        // 3. Optionally show feature points

    }

    func setupDetectButton() {
        detectButton.addTarget(self, action: #selector(togglePlaneDetection), for: .touchUpInside)
        view.addSubview(detectButton)
        detectButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            detectButton.widthAnchor.constraint(equalToConstant: 100),
            detectButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        sceneView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // 1. Get location of the tap gesture.


        // 2. Perform a raycast from the tap location to a horizontal plane.


        // 3.  Show a box, using makeBoxNode method, in the scene at the position where the user tapped.
    }

    func makeBoxNode() -> SCNNode {
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        return SCNNode(geometry: boxGeometry)
    }

    @objc func togglePlaneDetection() {
        // 1. Reset the session when turning the detection on


        // 2. Create new configuration for new detecting state


        // 3. Make the new configuration active


        let impact = UIImpactFeedbackGenerator(style: .heavy)
        impact.impactOccurred()
    }
}

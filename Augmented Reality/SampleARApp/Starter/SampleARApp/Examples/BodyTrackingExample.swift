//
//  BodyTrackingExample.swift.swift
//  SampleARApp
//
//  Created by Tony Ngo on 11.10.2022.
//

import Foundation
import ARKit

final class BodyTrackingExample: ARViewController {
    override func viewDidLoad() {
        setupBodyTracking()
        super.viewDidLoad()
    }
}

// MARK: - ARSessionDelegate

extension BodyTrackingExample: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        // 1. Iterate over all anchors added to the scene.


        // 2. Access only body anchors.


        // 3. Obtain transformation matrices for head, leftHand and rightHand.


        // 4. Get root position for the skeleton


        // 5. Get position of the head.


        // 6. Get positions of the hands.


        // 7. Check which hand is above head and show a sphere, otherwise remove the sphere.
    }
}

private extension BodyTrackingExample {
    func setupBodyTracking() {
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // 1. Create a configuration that supports trackings body parts.


        // 2. Assign scene view's session delegate to self to respond to session
    }

    func addNodeOrMove(to position: simd_float3) {
        if scene.rootNode.childNodes.count == 0 {
            let box = SCNSphere(radius: 0.2)
            box.firstMaterial?.diffuse.contents = UIColor.red

            let node = SCNNode(geometry: box)
            node.simdWorldPosition = position

            addNode(node)
        } else if let childNode = scene.rootNode.childNodes.first {
            childNode.simdWorldPosition = position
        }
    }
}

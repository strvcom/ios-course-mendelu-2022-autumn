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
        // Iterate over all anchors added to the scene.
        for anchor in anchors {
            // Access only body anchors.
            guard let bodyAnchor = anchor as? ARBodyAnchor else {
                continue
            }

            let transformFor = bodyAnchor.skeleton.modelTransform
            guard
                let headTransform = transformFor(.head),
                let leftHandTransform = transformFor(.leftHand),
                let rightHandTransform = transformFor(.rightHand),
                let leftShoulderTransform = transformFor(.leftShoulder),
                let rightShoulderTransform = transformFor(.rightShoulder),
                let cameraTransform = session.currentFrame?.camera.transform
            else {
                continue
            }

            // The body anchor's position is the root for all other anchors on the skeleton.
            // All other body parts' positions are relative to the root anchor.
            let rootPosition = bodyAnchor.transform.translation

            // To get a body part's position we need to add its translation vector to the root vector.
            let headPosition = rootPosition + headTransform.translation

            let handsPosition = (
                left: rootPosition + leftHandTransform.translation,
                right: rootPosition + rightHandTransform.translation
            )

            let cameraDirection = handsPosition.left - cameraTransform.translation

            // Create a vector in the direction going from the shoulder to the left hand.
            let leftHandVector = handsPosition.left - leftShoulderTransform.translation

            // Create a vector in the direction going from the right hand to the right shoulder.
            let rightHandVector = rightShoulderTransform.translation - handsPosition.right

            // The cross product point towards us if the hands do not intersect, otherwise the product points away from us.
            let crossProduct = cross(leftHandVector, rightHandVector)

            let dotProduct = dot(cameraDirection, crossProduct)

            // A positive dot product means that the directions are the same,
            // meaning that the cross product vector points in the same direction as the camera.
            if dotProduct > 0 {
                addNodeOrMove(to: headPosition)
            } else {
                removeAllNodes()
            }
        }
    }
}

private extension BodyTrackingExample {
    func setupBodyTracking() {
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Set a configuration that trackings body parts.
        configuration = ARBodyTrackingConfiguration()

        session.delegate = self

        sceneView.autoenablesDefaultLighting = true
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

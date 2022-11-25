//
//  CustomGeometryExtended.swift
//  SampleARApp
//
//  Created by Tony Ngo on 24.11.2022.
//

import Foundation
import SceneKit
import UIKit

final class CustomGeometryExtendedExample: ARViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.scene.background.contents = UIColor(red: 0.06, green: 0.08, blue: 0.09, alpha: 1.00)
        showPyramidNode()
    }
}

// MARK: - PyramidFace
private extension CustomGeometryExtendedExample {
    enum PyramidFace: CaseIterable{
        case front, left, right, back
        case bottomLeft, bottomRight
    }
}

private extension CustomGeometryExtendedExample {
    func showPyramidNode() {
        // 1. Create the node which will have the pyramid geometry


        // 2. Create vertices and define indices for each pyramid face


        // 3. Create the geometry


        // 4. Assign geometry to the pyramid node

    }

    func makeVertices(forFace face: PyramidFace, size: Float) -> [simd_float3] {
        // This method should create and appropriately position (rotate and move) vertices describing the specified face.
        fatalError("Not implemented")
    }
}

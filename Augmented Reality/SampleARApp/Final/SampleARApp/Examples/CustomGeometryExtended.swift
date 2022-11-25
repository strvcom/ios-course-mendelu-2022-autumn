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
        let pyramid = SCNNode()
        pyramid.simdWorldPosition = .init(0, 0, -0.1)
        addNode(pyramid)

        var vertices: [simd_float3] = []
        var indices: [Int32] = []
        let size: Float = 0.05

        // 2. Create vertices and define indices for each pyramid face
        PyramidFace.allCases.forEach { face in
            let faceVertices = makeVertices(forFace: face, size: size)
            let indicesCount = indices.count
            vertices.append(contentsOf: faceVertices)
            indices.append(contentsOf: faceVertices.enumerated().map { $0.offset + indicesCount }.map(Int32.init))
        }

        let colors: [SCNVector3] = [
            SCNVector3(0.846, 0.035, 0.708), // magenta
            SCNVector3(0.846, 0.035, 0.708), // magenta
            SCNVector3(0.001, 1.000, 0.603), // cyan
        ]

        // 3. Create the geometry
        let geometry = SCNGeometry(
            sources: [
                SCNGeometrySource(vertices: vertices.map(SCNVector3.init)),
                SCNGeometrySource(colors: indices.map { colors[Int($0) % 3] })
            ],
            elements: [SCNGeometryElement(indices: indices, primitiveType: .triangles)]
        )

        // 4. Assign geometry to the pyramid node
        pyramid.geometry = geometry
    }

    func makeVertices(forFace face: PyramidFace, size: Float) -> [simd_float3] {
        let halfSize = size / 2
        let topVertexRotationAngle = Float.pi * 0.25 // 45 degrees
        let topVertexRotationMatrix: SCNMatrix4
        let bottomVerticesRotationMatrix: SCNMatrix4
        let bottomVerticesTranslationMatrix: SCNMatrix4

        switch face {
        case .front:
            bottomVerticesRotationMatrix = SCNMatrix4MakeRotation(0, 0, 1, 0)
            bottomVerticesTranslationMatrix = SCNMatrix4MakeTranslation(0, 0, halfSize)
            topVertexRotationMatrix = SCNMatrix4MakeRotation(-topVertexRotationAngle, 1, 0, 0)
        case .right:
            bottomVerticesRotationMatrix = SCNMatrix4MakeRotation(.pi * 0.5, 0, 1, 0)
            bottomVerticesTranslationMatrix = SCNMatrix4MakeTranslation(halfSize, 0, 0)
            topVertexRotationMatrix = SCNMatrix4MakeRotation(topVertexRotationAngle, 0, 0, 1)
        case .back:
            bottomVerticesRotationMatrix = SCNMatrix4MakeRotation(.pi, 0, 1, 0)
            bottomVerticesTranslationMatrix = SCNMatrix4MakeTranslation(0, 0, -halfSize)
            topVertexRotationMatrix = SCNMatrix4MakeRotation(topVertexRotationAngle, 1, 0, 0)
        case .left:
            bottomVerticesRotationMatrix = SCNMatrix4MakeRotation(.pi * -0.5, 0, 1, 0)
            bottomVerticesTranslationMatrix = SCNMatrix4MakeTranslation(-halfSize, 0, 0)
            topVertexRotationMatrix = SCNMatrix4MakeRotation(-topVertexRotationAngle, 0, 0, 1)
        default:
            return []
        }

        // Rotate first, then translate.
        let leftVertex = simd_float4x4(bottomVerticesTranslationMatrix) * simd_float4x4(bottomVerticesRotationMatrix) * simd_float4(-halfSize, 0, 0, 1)
        let rightVertex = simd_float4x4(bottomVerticesTranslationMatrix) * simd_float4x4(bottomVerticesRotationMatrix) * simd_float4(halfSize, 0, 0, 1)

        // Translate, then rotate.
        // The y-axis position of the top vertex is not 100% correct, use Pythagoras theoream to get the precise value from the size
        let topVertex = simd_float4x4(topVertexRotationMatrix) * simd_float4x4(bottomVerticesTranslationMatrix) * simd_float4(0, halfSize, 0, 1)

        // Either of these combinations is OK as long as it they're counterclockwise — (L)eft, (R)ight, (T)op.
        // LRT, RTL, TLR
        return [.init(leftVertex), .init(rightVertex), .init(topVertex)]
    }
}

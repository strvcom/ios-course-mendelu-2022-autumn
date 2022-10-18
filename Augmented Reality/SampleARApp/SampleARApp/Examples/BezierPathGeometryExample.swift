//
//  BezierPathGeometryExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 06.09.2022.
//

import Foundation
import SceneKit
import UIKit

final class BezierPathGeometryExample: ARViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomBezierPathGeometry()
    }
}

private extension BezierPathGeometryExample {
    func showCustomBezierPathGeometry() {
        // 1. Create UIBezierPath
        let path = makeBezierPath()

        // 2. Create a geometry
        let shapeGeometry = SCNShape(path: path, extrusionDepth: 0.2)
        shapeGeometry.firstMaterial?.diffuse.contents = UIColor.green

        // 3. Create a node
        let node = SCNNode(geometry: shapeGeometry)
        node.position = .init(x: 0, y: 0, z: -1)

        addNode(node)
    }

    /// Source: https://suragch.medium.com/designing-and-drawing-bézier-paths-in-ios-c886c3050ffb
    func makeBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        // starting point for the path (bottom left)
        path.move(to: CGPoint(x: 2, y: 26))

        path.addLine(to: CGPoint(x: 2, y: 15))

        path.addCurve(
            to: CGPoint(x: 0, y: 12), // ending point
            controlPoint1: CGPoint(x: 2, y: 14),
            controlPoint2: CGPoint(x: 0, y: 14)
        )

        path.addLine(to: CGPoint(x: 0, y: 2))

        path.addArc(
            withCenter: CGPoint(x: 2, y: 2),
            radius: 2,
            startAngle: .pi,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: 8, y: 0))

        path.addArc(
            withCenter: CGPoint(x: 8, y: 2),
            radius: 2,
            startAngle: 3 * .pi / 2,
            endAngle: 0,
            clockwise: true
        )

        path.addLine(to: CGPoint(x: 10, y: 12))

        path.addCurve(
            to: CGPoint(x: 8, y: 15),
            controlPoint1: CGPoint(x: 10, y: 14),
            controlPoint2: CGPoint(x: 8, y: 14)
        )

        path.addLine(to: CGPoint(x: 8, y: 26))
        path.close()
        path.apply(.init(scaleX: 0.05, y: 0.05))
        return path
    }
}

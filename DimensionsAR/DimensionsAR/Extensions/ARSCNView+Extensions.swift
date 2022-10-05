//
//  ARSCNView+Extensions.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import ARKit

extension ARSCNView {
    /// Returns the projection of a point from 2D view onto a plane in its coordinate system.
    /// - Returns: This method returns nil if the projected point does not intersect the specified plane.
    func unprojectPointLocal(_ point: CGPoint, ontoPlane planeTransform: float4x4) -> SIMD3<Float>? {
        guard let result = unprojectPoint(point, ontoPlane: planeTransform) else {
            return nil
        }

        let point = SIMD4<Float>(result, 1)
        let localResult = planeTransform.inverse * point
        return localResult.xyz
    }
}

//
//  Ray.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 05.10.2022.
//

import SceneKit

struct Ray {
    /// A ray's origin.
    let origin: SIMD3<Float>

    /// A ray's direction.
    let direction: SIMD3<Float>

    init(origin: SIMD3<Float>, direction: SIMD3<Float>) {
        self.origin = origin
        self.direction = direction
    }
}

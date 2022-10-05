//
//  FaceDrag.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import SceneKit

struct FaceDrag {
    /// The face that is being dragged.
    var face: BoundingBoxFace

    /// The transform matrix.
    var planeTransform: float4x4

    /// The world position at the time of drag gesture.
    var beginWorldPos: simd_float3

    /// The face's extent at the time of drag gesture.
    var beginExtent: simd_float3
}

extension FaceDrag {
    /// The dragged face's normal vector.
    var normal: simd_float3 {
        face.dragAxis.normal
    }
}

//
//  simd_float4x4+Extension.swift
//  SampleARApp
//
//  Created by Tony Ngo on 18.10.2022.
//

import SceneKit

extension simd_float4x4  {
    /// Returns a 3x1 translation vector from the matrix.
    var translation: simd_float3 {
        simd_make_float3(columns.3)
    }
}

// MARK: - CustomStringConvertible
extension simd_float4x4: CustomStringConvertible {
    public var description: String {
        let col0 = columns.0
        let col1 = columns.1
        let col2 = columns.2
        let col3 = columns.3

        return """
        |\(String(format: "%.2f", col0.x))\t\(String(format: "%.2f", col1.x))\t\(String(format: "%.2f", col2.x))\t\(String(format: "%.2f", col3.x))|
        |\(String(format: "%.2f", col0.y))\t\(String(format: "%.2f", col1.y))\t\(String(format: "%.2f", col2.y))\t\(String(format: "%.2f", col3.y))|
        |\(String(format: "%.2f", col0.z))\t\(String(format: "%.2f", col1.z))\t\(String(format: "%.2f", col2.z))\t\(String(format: "%.2f", col3.z))|
        |\(String(format: "%.2f", col0.w))\t\(String(format: "%.2f", col1.w))\t\(String(format: "%.2f", col2.w))\t\(String(format: "%.2f", col3.w))|
        """
    }
}

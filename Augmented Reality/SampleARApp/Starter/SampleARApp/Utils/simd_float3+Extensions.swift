//
//  simd_float3+Extensions.swift
//  SampleARApp
//
//  Created by Tony Ngo on 25.11.2022.
//

import simd

extension simd_float3 {
    init(_ simd4: simd_float4) {
        self = simd_make_float3(simd4)
    }
}

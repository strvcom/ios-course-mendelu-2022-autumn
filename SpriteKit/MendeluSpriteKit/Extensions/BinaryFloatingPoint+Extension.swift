//
//  BinaryFloatingPoint+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

extension BinaryFloatingPoint {
    func normalize(
        min: Self,
        max: Self,
        from a: Self = 0,
        to b: Self = 1
    ) -> Self {
        (b - a) * ((self - min) / (max - min)) + a
    }
}

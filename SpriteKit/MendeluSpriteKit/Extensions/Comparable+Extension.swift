//
//  Comparable+Extension.swift
//  MendeluSpriteKit
//
//  Created by Róbert Oravec on 25.09.2022.
//

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        max(range.lowerBound, min(self, range.upperBound))
    }
}

//
//  GestureManager.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import ARKit
import Combine

final class GestureManager {
    // MARK: - Public Properties

    var dimensionsPublisher: AnyPublisher<BoundingBox.Dimensions, Never> {
        dimensionsSubject.eraseToAnyPublisher()
    }

    // MARK: - Private Properties

    private var isPackageNodeInHierarchy: Bool {
        tapGestureRecognized
    }

    private(set) lazy var boundingBox: BoundingBox = BoundingBox(sceneView: sceneView)
    private(set) var tapGestureRecognized: Bool = false

    private(set) var lastPannedLocationZAxis: CGFloat?
    private(set) var lastPanLocation: simd_float3?
    private(set) var lastRotation: simd_float3?
    private(set) var currentDraggedFace: FaceDrag?
    private var sceneView: ARSCNView = ARSCNView()
    private let dimensionsSubject: PassthroughSubject<BoundingBox.Dimensions, Never> = .init()
}

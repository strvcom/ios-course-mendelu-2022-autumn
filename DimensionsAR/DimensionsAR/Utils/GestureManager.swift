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

// MARK: - Public Methods

extension GestureManager {
    func setupGestures(in view: ARSCNView) {
        sceneView = view
        setupGestures()
    }
}

// MARK: - Private Methods

private extension GestureManager {
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))

        [tapGesture]
            .forEach(sceneView.addGestureRecognizer)
    }

    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)

        guard
            isPackageNodeInHierarchy == false,
            let query = sceneView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .horizontal),
            let result = sceneView.session.raycast(query).first
        else {
            return
        }

        boundingBox.simdPosition = simd_float3(result.worldTransform.columns.3)
        sceneView.scene.rootNode.addChildNode(boundingBox)
        dimensionsSubject.send(boundingBox.dimensions)
        tapGestureRecognized = true
    }
}

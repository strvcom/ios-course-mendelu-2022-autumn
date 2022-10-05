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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))

        [tapGesture, panGesture]
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

// MARK: - Pan Gesture

private extension GestureManager {
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard isPackageNodeInHierarchy else {
            return
        }

        let location = gesture.location(in: sceneView)

        switch gesture.state {
        case .began:
            guard let result = sceneView.hitTest(location).first else {
                return
            }

            let worldCoordinates = result.worldCoordinates
            lastPanLocation = simd_float3(worldCoordinates)
            lastPannedLocationZAxis = CGFloat(sceneView.projectPoint(worldCoordinates).z)
        case .changed:
            guard let lastPanLocation = lastPanLocation else {
                return
            }

            let worldPosition = simd_float3(sceneView.unprojectPoint(
                SCNVector3(location.x, location.y, lastPannedLocationZAxis ?? 0)
            ))

            let translation = worldPosition - lastPanLocation
            boundingBox.simdLocalTranslate(by: translation)
            self.lastPanLocation = worldPosition
        default:
            lastPanLocation = nil
            lastPannedLocationZAxis = nil
        }
    }
}

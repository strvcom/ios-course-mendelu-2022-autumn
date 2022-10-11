//
//  ViewController.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import ARKit
import Combine
import SceneKit
import UIKit

final class ARViewController: UIViewController {
    // MARK: - UI Components

    @IBOutlet private var sceneView: ARSCNView!
    private let dimensionsView = DimensionsView()

    // MARK: - Private Properties

    private let gestureManager = GestureManager()
    private var cancelables: Set<AnyCancellable> = []

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            // Without this configuration the mesh anchor will not be added to the scene.
            configuration.sceneReconstruction = .mesh
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - ARSCNViewDelegate

extension ARViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard
            let meshAnchor = anchor as? ARMeshAnchor,
            let geometry = meshAnchor.sceneGeometry()
        else {
            return nil
        }

        // Enable gestures only if a mesh anchor was added to the scene.
        gestureManager.isGestureEnabled = true

        let node = SCNNode(geometry: geometry)

        // Change the rendering order so it renders before our virtual object.
        node.renderingOrder = -1

        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard
            let meshAnchor = anchor as? ARMeshAnchor,
            let geometry = meshAnchor.sceneGeometry()
        else {
            return
        }

        // Update the node for mesh anchor with updated geometry.
        node.geometry = geometry
    }
}

// MARK: - UI Setup
extension ARViewController {
    func setup() {
        gestureManager.setupGestures(in: sceneView)
        setupSceneView()
        setupDimensionsView()
    }

    func setupSceneView() {
        // Set the view's delegate.
        sceneView.delegate = self

        // Show statistics such as fps and timing information.
        sceneView.showsStatistics = true

        // Enable automatic lighting by SceneKit.
        sceneView.autoenablesDefaultLighting = true
    }

    func setupDimensionsView() {
        sceneView.addSubview(dimensionsView)
        dimensionsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimensionsView.leadingAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            dimensionsView.topAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.topAnchor)
        ])

        // Subscribe for dimensions changes to update the UI.
        gestureManager.dimensionsPublisher
            .sink { [weak self] in
                let formattedDimensions = $0.formattedDimensions
                self?.dimensionsView.widthLabel.text = "Width: " + formattedDimensions.width
                self?.dimensionsView.heightLabel.text = "Height: " + formattedDimensions.height
                self?.dimensionsView.depthLabel.text = "Depth: " + formattedDimensions.depth
            }
            .store(in: &cancelables)
    }
}

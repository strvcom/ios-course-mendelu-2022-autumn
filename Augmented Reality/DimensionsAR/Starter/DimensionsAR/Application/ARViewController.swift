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

// TODO: 0 - the app + extensions

final class ARViewController: UIViewController {
    // MARK: - UI Components

    @IBOutlet private var sceneView: ARSCNView!
    @IBOutlet private var resetButton: UIButton!
    private let dimensionsView = DimensionsView()

    // MARK: - Private Properties

    private let gestureManager = GestureManager()
    private var coachingOverlayShouldReactive: Bool = true
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
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Create a plane to visualize the estimated shape of the detected plane.
        // TODO: 1
        
        // Validate anchor and create plane geometry

        // Create a node to visualize the plane's bounding rectangle.
        
        // Change the rendering order so it renders before our virtual object.
        
        // Enable gestures only if a plane anchor was added to the scene.

        // Disable coaching overlay activation once a plane is detected.
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // TODO: 2
        // Update plane geometry
    }
}

// MARK: - ARCoachingOverlayViewDelegate

extension ARViewController: ARCoachingOverlayViewDelegate {
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        if coachingOverlayShouldReactive {
            coachingOverlayView.setActive(true, animated: true)
        }
    }
}

// MARK: - UI Setup
extension ARViewController {
    func setup() {
        gestureManager.setupGestures(in: sceneView)
        setupSceneView()
        setupDimensionsView()
        setupResetButton()
    }

    func setupSceneView() {
        // Set the view's delegate.
        sceneView.delegate = self

        // Show statistics such as fps and timing information.
        sceneView.showsStatistics = true

        // Enable automatic lighting by SceneKit.
        sceneView.autoenablesDefaultLighting = true

        sceneView.addCoaching(delegate: self)
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

    func setupResetButton() {
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }

    @objc func resetButtonTapped() {
        gestureManager.boundingBox.extent = SIMD3(0.1, 0.1, 0.1)
        gestureManager.boundingBox.removeFromParentNode()
    }
}

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

final class ARViewController: UIViewController, ARSCNViewDelegate {
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

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

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

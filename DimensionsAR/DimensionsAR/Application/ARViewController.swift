//
//  ViewController.swift
//  DimensionsAR
//
//  Created by Tony Ngo on 06.10.2022.
//

import UIKit
import SceneKit
import ARKit

final class ARViewController: UIViewController, ARSCNViewDelegate {
    // MARK: - UI Components

    @IBOutlet var sceneView: ARSCNView!

    // MARK: - Private Properties

    private let gestureManager = GestureManager()

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
        setupSceneView()
    }

    func setupSceneView() {
        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
}

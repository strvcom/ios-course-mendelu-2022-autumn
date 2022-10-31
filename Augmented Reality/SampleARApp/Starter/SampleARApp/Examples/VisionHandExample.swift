//
//  VisionExample.swift
//  SampleARApp
//
//  Created by Tony Ngo on 07.09.2022.
//

import ARKit
import Foundation
import Vision

final class VisionHandExample: ARViewController {

    private let visionQueue = DispatchQueue(label: "com.strv.mendelu.SampleARApp.visionQueue")

    private let minimumConfidence: Float = 0.3

    private let pointPath = UIBezierPath()

    private lazy var coordinatesAdapter = CoordinatesAdapter(screenSize: sceneView.bounds.size)

    private lazy var overlayLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = sceneView.frame
        return layer
    }()

    private let indexTipPoint: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()

    override func viewDidLoad() {
        setupVision()
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - ARSessionDelegate

extension VisionHandExample: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let capturedImage = frame.capturedImage

        // The captured image is in horizontal orientation so we need to switch the height and width.
        coordinatesAdapter.imageSize = .init(width: capturedImage.height, height: capturedImage.width)

        // 1. Create a request


        // 2. Create request handler responsible for image analysis


        // 3. Perform request


        // 4. Access request's results - observations


        // 5. Iterate through observations and access wanted recognized points.


        // 6. Only accept points with confidence (precision) higher than the minimum.


        // 7. Show the recognized point as a simple 2D point on screen.
    }
}

private extension VisionHandExample {
    func setupView() {
        overlayLayer.fillColor = UIColor.green.cgColor
        view.layer.addSublayer(overlayLayer)
    }

    func setupVision() {
        session.delegate = self
    }

    func showIndexFingerPoint(_ point: CGPoint) {
        let screenPoint = coordinatesAdapter.screenCoordinates(normalizedImagePoint: point)

        pointPath.removeAllPoints()
        pointPath.move(to: screenPoint)
        pointPath.addArc(
            withCenter: screenPoint,
            radius: 5,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )

        overlayLayer.path = pointPath.cgPath
    }
}

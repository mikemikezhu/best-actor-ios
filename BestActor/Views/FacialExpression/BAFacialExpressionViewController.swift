//
//  BAFacialExpressionViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAFacialExpressionViewController: BABaseViewController, UINavigationControllerDelegate {

	@IBOutlet weak var facialExpressionLabel: BATitleLabel!
	@IBOutlet weak var facialExpressionImageView: UIImageView!

	@IBOutlet weak var loadingContainerView: UIView!

	override func viewDidLoad() {

		super.viewDidLoad()

		// Load facial expression
		let identifier = String(describing: BAFacialExpressionService.self)
		let service = BACoreServiceFactory.sharedFactory.findService(identifier)

		if let facialExpressionService = service as? BAFacialExpressionService {

			if let facialExpression = facialExpressionService.loadFacialExpression() {
				BALogger.info("Load facial expression: \(facialExpression)")
				configureFacialExpressionLabel(facialExpression)
				configureFacialExpressionImageView(facialExpression)
			}
		}

		// Hide loading container view
		hideLoadingContainerView()
	}

	// MARK: - IBAction

	@IBAction func takePhoto(_ sender: UIButton) {

		// Present image picker to take photo
		let picker = UIImagePickerController()

		picker.delegate = self
		picker.sourceType = .camera
		picker.cameraDevice = .front

		present(picker, animated: true) {
			BALogger.info("Present image picker to take photo")
		}
	}

	// MARK: - Private methods

	private func configureFacialExpressionLabel(_ facialExpression: String) {

		facialExpressionLabel.text = facialExpression.uppercased()
	}

	private func configureFacialExpressionImageView(_ facialExpression: String) {

		facialExpressionImageView.image = UIImage(named: facialExpression)
	}

	private func displayLoadingContainerView() {

		loadingContainerView.isHidden = false
		loadingContainerView.isUserInteractionEnabled = true
	}

	private func hideLoadingContainerView() {

		loadingContainerView.isHidden = true
		loadingContainerView.isUserInteractionEnabled = false
	}
}

extension BAFacialExpressionViewController: UIImagePickerControllerDelegate {

	// MARK: - UIImagePickerControllerDelegate

	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		// Dismiss image picker after taking photo
		picker.dismiss(animated: true) {

			BALogger.info("Dismiss image picker after taking photo")

			var image: UIImage
			if let possibleImage = info[.editedImage] as? UIImage {
				image = possibleImage
			} else if let possibleImage = info[.originalImage] as? UIImage {
				image = possibleImage
			} else {
				return
			}

			// Display loading container view
			self.displayLoadingContainerView()

			// Predict image
			let identifier = String(describing: BAPredictionService.self)
			let service = BACoreServiceFactory.sharedFactory.findService(identifier)

			if let predictionService = service as? BAPredictionService {
				predictionService.predictFacialExpression(image)
			}
		}
	}
}

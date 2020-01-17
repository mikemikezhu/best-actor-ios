//
//  BAFacialExpressionViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAFacialExpressionViewController: BABaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var facialExpressionLabel: BATitleLabel!
	@IBOutlet weak var facialExpressionImageView: UIImageView!

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

	// MARK: - UIImagePickerControllerDelegate

	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

		// Dismiss image picker after taking photo
		picker.dismiss(animated: true) {
			BALogger.info("Dismiss image picker after taking photo")
		}
	}

	// MARK: - Private methods

	private func configureFacialExpressionLabel(_ facialExpression: String) {

		facialExpressionLabel.text = facialExpression.uppercased()
	}

	private func configureFacialExpressionImageView(_ facialExpression: String) {

		facialExpressionImageView.image = UIImage(named: facialExpression)
	}
}

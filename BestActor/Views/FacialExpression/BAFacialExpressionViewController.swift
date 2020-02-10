//
//  BAFacialExpressionViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

fileprivate struct BAFacialExpressionViewControllerConstants {

	static let SEGUE_TO_SCORE_IDENTIFIER = "segue_to_score"
}

class BAFacialExpressionViewController: BABaseViewController, UINavigationControllerDelegate {

	@IBOutlet weak var facialExpressionLabel: BATitleLabel!
	@IBOutlet weak var facialExpressionImageView: UIImageView!

	@IBOutlet weak var loadingContainerView: UIView!

	private var image: UIImage?
	private var score: Float?
	private var facialExpression: String?

	override func viewDidLoad() {

		super.viewDidLoad()

		// Load facial expression
		let identifier = String(describing: BAFacialExpressionService.self)
		let service = BACoreServiceFactory.sharedFactory.findService(identifier)

		if let facialExpressionService = service as? BAFacialExpressionService {

			if let facialExpression = facialExpressionService.loadFacialExpression() {
				BALogger.info("Load facial expression: \(facialExpression)")
				self.facialExpression = facialExpression
				configureFacialExpressionLabel(facialExpression)
				configureFacialExpressionImageView(facialExpression)
			}
		}

		// Hide loading container view
		hideLoadingContainerView()
	}
}

// MARK: - UIImagePickerControllerDelegate

extension BAFacialExpressionViewController: UIImagePickerControllerDelegate {

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

			// Predict facial expression in image
			self.predictFacialExpression(image)
		}
	}
}

// MARK: - IBAction

extension BAFacialExpressionViewController {

	@IBAction func takePhoto(_ sender: BAButton) {

		if !UIDevice.current.isSimulator {
			takePhoto()
		} else {
			BALogger.warn("Please run the model on iOS devices >= 13.0")
		}
	}
}

// MARK: - Navigation

extension BAFacialExpressionViewController {

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == BAFacialExpressionViewControllerConstants.SEGUE_TO_SCORE_IDENTIFIER {
			if let scoreViewController = segue.destination as? BAFacialExpressionScoreViewController {
				// Make sure the image and score shall exist
				scoreViewController.image = image!
				scoreViewController.score = score!
			}
		}
	}
}

// MARK: - Private methods

extension BAFacialExpressionViewController {

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

	private func takePhoto() {

		// Present image picker to take photo
		let picker = UIImagePickerController()

		picker.delegate = self
		picker.sourceType = .camera
		picker.cameraDevice = .front

		let width = view.bounds.width
		let height = view.bounds.height

		let roiSideLength = CGFloat(BAGlobalConstants.ROI_SIDE_FACTOR) * width

		let x = (width - roiSideLength) / 2
		let y = (height - roiSideLength) / 2
		let frame = CGRect(x: x, y: y, width: roiSideLength, height: roiSideLength)

		let cameraOverlayView = BACameraOverlayView(frame: frame)
		picker.cameraOverlayView = cameraOverlayView

		present(picker, animated: true) {
			BALogger.info("Present image picker to take photo")
		}
	}

	private func predictFacialExpression(_ image: UIImage) {

		let identifier = String(describing: BAPredictionService.self)
		let service = BACoreServiceFactory.sharedFactory.findService(identifier)

		if let predictionService = service as? BAPredictionService,
			let facialExpression = self.facialExpression {

			do {
				try predictionService.predictFacialExpression(image, facialExpression, { (score, error) in

					if let error = error {

						//						if case BAError.failToDetectFace = error {
						//
						//							// Show alert to take photo again
						//							let alert = UIAlertController(title: "Face cannot be detected",
						//														  message: "Please kindly take the photo again. Make sure your face appears in the center of the camera.",
						//														  preferredStyle: .alert)
						//
						//							let action = UIAlertAction(title: "Take photo again", style: .default, handler: {action in
						//
						//								// Hide loading container view
						//								self.hideLoadingContainerView()
						//
						//								// Take photo again if fail to detect face
						//								self.takePhoto()
						//							})
						//
						//							alert.addAction(action)
						//							self.present(alert, animated: true)
						//						}
					} else {

						// Set score and image
						self.image = image
						self.score = score

						// Segue to score page
						self.performSegue(withIdentifier: BAFacialExpressionViewControllerConstants.SEGUE_TO_SCORE_IDENTIFIER,
										  sender: self)
					}
				})
			} catch {
				BALogger.error("Fail to predict facial expression")
			}
		}
	}
}

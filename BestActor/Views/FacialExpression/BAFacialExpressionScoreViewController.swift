//
//  BAFacialExpressionScoreViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/1/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAFacialExpressionScoreViewController: BABaseViewController {

	// Make sure image and score shall exist
	// When the view controller initialized
	var image: UIImage!
	var score: Double!

	@IBOutlet weak var faceImageView: BAPhotoFrameImageView!
	@IBOutlet weak var scoreLabel: BATitleLabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		faceImageView.image = image
		scoreLabel.text = String(score)
	}
}

// MARK: - IBAction

extension BAFacialExpressionScoreViewController {

	@IBAction func sharePhoto(_ sender: BAButton) {
		sharePhoto()
	}
}

// MARK: - Private methods

extension BAFacialExpressionScoreViewController {

	private func sharePhoto() {

		guard let score = score, let image = image else { return }

		let message = "I won \(score) in BestApp. Please come and see!"
		let activityItems = [message, image] as [Any]

		let activityViewController = UIActivityViewController(activityItems: activityItems,
															  applicationActivities: nil)
		activityViewController.excludedActivityTypes = [.print,
														.openInIBooks,
														.addToReadingList]
		present(activityViewController,
				animated: true,
				completion: nil)
	}
}

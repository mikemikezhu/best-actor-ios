//
//  BAFacialExpressionDiscriptionViewController.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAFacialExpressionDiscriptionViewController: BABaseViewController {

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

	private func configureFacialExpressionLabel(_ facialExpression: String) {

		facialExpressionLabel.text = facialExpression.uppercased()
	}

	private func configureFacialExpressionImageView(_ facialExpression: String) {

		facialExpressionImageView.image = UIImage(named: facialExpression)
	}
}

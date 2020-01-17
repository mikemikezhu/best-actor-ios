//
//  BAFacialExpressionService.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAFacialExpressionService: NSObject {

	private var facialExpressions: [String]?
	private(set) var selectedFacialExpression: String?

	override init() {

		super.init()
		facialExpressions = loadFacialExpressions()
	}

	func loadFacialExpression() -> String? {

		guard let facialExpressions = facialExpressions else {
			return nil
		}

		selectedFacialExpression = facialExpressions.randomElement()
		return selectedFacialExpression
	}

	private func loadFacialExpressions() -> [String]? {

		// Load facial expressions from plist file
		if let path = Bundle.main.path(forResource: "FacialExpression", ofType: "plist") {

			if let facialExpressions = NSArray(contentsOfFile: path) as? [String] {
				print("[INFO] - Successfully loaded facial expressions: \(String(describing: facialExpressions))")
				return facialExpressions
			}
		}

		print("[WARN] - Failed to load facial expressions")
		return nil
	}
}

// MARK: - BAService

extension BAFacialExpressionService: BAService {

	var identifier: String {
		return String(describing: BAFacialExpressionService.self)
	}
}

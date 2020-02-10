//
//  BAServiceManager.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAServiceManager {

	static let sharedManager = BAServiceManager()

	private init() {}

	func initServices() {

		BALogger.info("Init services")

		let facialExpressionService = BAFacialExpressionService()
		BACoreServiceFactory.sharedFactory.registerService(facialExpressionService)

		let processImageService = BAProcessImageService()
		BACoreServiceFactory.sharedFactory.registerService(processImageService)

		let predictionService = BAPredictionService(processImageService)
		BACoreServiceFactory.sharedFactory.registerService(predictionService)
	}
}

//
//  BACoreServiceFactory.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BACoreServiceFactory {

	static let sharedFactory = BACoreServiceFactory()
	var serviceHolder: [String : BAService] = [:]

	private init() {}

	func registerService(_ service: BAService) {

		// Register service in factory
		serviceHolder[service.identifier] = service
	}

	func findService(_ identifier: String) -> BAService? {

		// Find service in factory
		return serviceHolder[identifier]
	}
}

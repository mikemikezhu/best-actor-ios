//
//  BAModelLabelConverter.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/1/30.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAModelLabelConverter {

	class func convertModelLabel(_ label: String) -> String? {

		if label == "happy" {
			return "0"
		} else if label == "sad" {
			return "1"
		} else if label == "surprise" {
			return "2"
		}

		return nil
	}
}

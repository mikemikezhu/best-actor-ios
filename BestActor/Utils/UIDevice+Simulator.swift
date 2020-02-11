//
//  UIDevice+Simulator.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/1/30.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

extension UIDevice {

	var isSimulator: Bool {
		#if IOS_SIMULATOR && DEBUG
		return true
		#else
		return false
		#endif
	}
}

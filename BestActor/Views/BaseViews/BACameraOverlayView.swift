//
//  BACameraOverlayView.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/2/10.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BACameraOverlayView: UIView {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	private func commonInit() {

		// Create outline border for the camera overlay view
		layer.borderWidth = 1.0
		layer.borderColor = UIColor.customCameraOverlayViewBorderColor.cgColor

		// Set background color
		backgroundColor = UIColor.customCameraOverlayViewBackgroundColor
	}
}

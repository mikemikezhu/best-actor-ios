//
//  BAPhotoFrameImageView.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/14/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAPhotoFrameImageView: UIImageView {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	private func commonInit() {

		layer.borderWidth = 10
		layer.borderColor = UIColor.customPhotoFrameBorderColor.cgColor

		layer.shadowColor = UIColor.customPhotoFrameShadowColor.cgColor
		layer.shadowOffset = CGSize(width: 10, height: 10)
		layer.shadowOpacity = 0.5
		layer.masksToBounds = false
	}
}

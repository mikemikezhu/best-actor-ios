//
//  BATextLabel.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/14/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BATextLabel: UILabel {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	private func commonInit() {
		font = UIFont.customTextFont
		textColor = UIColor.customTextColor
		numberOfLines = 0 // Display multiple lines
	}
}

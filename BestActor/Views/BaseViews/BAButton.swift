//
//  BAButton.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/14/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

class BAButton: UIButton {

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	private func commonInit() {

		titleLabel?.font = UIFont.customButtonFont
		titleLabel?.adjustsFontSizeToFitWidth = true

		setTitleColor(UIColor.customButtonColor, for: .normal)

		layer.cornerRadius = bounds.height / 2
		layer.borderWidth = 1
		layer.borderColor = UIColor.customButtonColor.cgColor

		backgroundColor = UIColor.clear
	}
}

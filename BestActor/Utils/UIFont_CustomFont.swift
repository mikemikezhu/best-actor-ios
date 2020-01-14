//
//  UIFont_CustomFont.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/14/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

extension UIFont {

	class var customTitleFont: UIFont {
		guard let customFont = UIFont.init(name: "HoboStd", size: 50) else {
			fatalError("""
				Failed to load the "HoboStd" font.
				Make sure the font file is included in the project and the font name is spelled correctly.
				"""
			)
		}
		return customFont
	}

	class var customButtonFont: UIFont {
		guard let customFont = UIFont.init(name: "OpenSans-CondensedBold", size: 20) else {
			fatalError("""
				Failed to load the "OpenSans-CondensedBold" font.
				Make sure the font file is included in the project and the font name is spelled correctly.
				"""
			)
		}
		return customFont
	}

	class var customTextFont: UIFont {
		guard let customFont = UIFont.init(name: "OpenSans-CondensedLight", size: 20) else {
			fatalError("""
				Failed to load the "OpenSans-CondensedLight" font.
				Make sure the font file is included in the project and the font name is spelled correctly.
				"""
			)
		}
		return customFont
	}
}

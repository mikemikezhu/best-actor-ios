//
//  UIColor+CustomColor.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/14/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

extension UIColor {

	class var customBackgroundColor: UIColor {
		return UIColor.init(red: 135.0/255.0,
							green: 203.0/255.0,
							blue: 235.0/255.0,
							alpha: 1.0)
	}

	class var customLoadingViewBackgroundColor: UIColor {
		return UIColor.init(red: 0.0,
							green: 0.0,
							blue: 0.0,
							alpha: 0.8)
	}

	class var customCameraOverlayViewBorderColor: UIColor {
		return UIColor.white
	}

	class var customCameraOverlayViewBackgroundColor: UIColor {
		return UIColor.clear
	}

	class var customTitleColor: UIColor {
		return UIColor.white
	}

	class var customSubtitleColor: UIColor {
		return UIColor.white
	}

	class var customButtonColor: UIColor {
		return UIColor.white
	}

	class var customTextColor: UIColor {
		return UIColor.white
	}

	class var customPhotoFrameBorderColor: UIColor {
		return UIColor.white
	}

	class var customPhotoFrameShadowColor: UIColor {
		return UIColor.black
	}
}

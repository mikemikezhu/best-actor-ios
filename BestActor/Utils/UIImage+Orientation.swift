//
//  UIImage+Orientation.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/18/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

extension UIImage {

	func fixOrientation() -> UIImage {

		// UIImage has a "EXIF" flag to specify the orientaion
		// However, OpenCV is not able to recognize the image orientation
		// Therefore, rotate the image if it is taken in portrait model
		// Reference:
		// https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload/10611036#10611036

		if (imageOrientation == .up) {
			return self
		}

		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		draw(in: rect)

		let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		return normalizedImage
	}
}

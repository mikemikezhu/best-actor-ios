//
//  BAPredictionService.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/18/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit

fileprivate struct BAPredictionServiceConstants {

	static let IMAGE_DIRECTORY_PATH = "images"
	static let IMAGE_COMPRESSION_QUALITY: CGFloat = 0.5
}

class BAPredictionService: NSObject {

	func predictFacialExpression(_ image: UIImage) -> Double {

		// Detect face in the image
		let normalizedImage = image.fixOrientation()
		guard let faceImage = OpenCVWrapper.detectFace(normalizedImage) else {
			BALogger.warn("Fail to detect any face in the image")
			return 0
		}

		#if DEBUG
		// Save face image for debugging purpose
		saveImageFile(faceImage)
		#endif

		return 0
	}

	private func saveImageFile(_ image: UIImage) {

		// Save image file for debugging purpose
		let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(BAPredictionServiceConstants.IMAGE_DIRECTORY_PATH)

		if !FileManager.default.fileExists(atPath: path) {
			try! FileManager.default.createDirectory(atPath: path,
													 withIntermediateDirectories: true,
													 attributes: nil)
		}

		guard let url = NSURL(string: path) else {
			BALogger.warn("Fail to find path: \(path)")
			return
		}

		let date = Date().toString()
		let imageName = "\(date)_image.jpg"
		guard let imagePath = url.appendingPathComponent(imageName) else {
			BALogger.warn("Fail to create image: \(imageName)")
			return
		}

		let urlString: String = imagePath.absoluteString
		BALogger.info("Save to image path: \(urlString)")

		let imageData = image.jpegData(compressionQuality: BAPredictionServiceConstants.IMAGE_COMPRESSION_QUALITY)
		if !FileManager.default.createFile(atPath: urlString as String,
										   contents: imageData,
										   attributes: nil) {
			BALogger.warn("Fail to save to image path: \(urlString)")
		}
	}
}

// MARK: - BAService

extension BAPredictionService: BAService {

	var identifier: String {
		return String(describing: BAPredictionService.self)
	}
}

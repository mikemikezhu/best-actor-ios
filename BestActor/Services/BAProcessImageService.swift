//
//  BAProcessImageService.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/2/10.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit
import Accelerate

fileprivate struct BAProcessImageServiceConstants {

	static let IMAGE_DIRECTORY_PATH = "images"
	static let IMAGE_COMPRESSION_QUALITY: CGFloat = 0.5
}

class BAProcessImageService {

	// MARK: - Internal methods

	func processImage(_ image: UIImage,
					  _ roiSideLength: CGFloat,
					  _ resizedSideLength: CGFloat) -> UIImage? {

		// 1. Crop the ROI square
		guard let croppedImage = cropRoiSquare(image, roiSideLength) else {
			BALogger.error("Fail to crop ROI of image to square")
			return nil
		}

		// 2. Resize the image
		guard let resizedImage = resizeImage(croppedImage, resizedSideLength) else {
			BALogger.error("Fail to resize the image")
			return nil
		}

		#if DEBUG
		// Save face image data for debugging purpose
		saveImageFile(resizedImage)
		#endif

		return resizedImage
	}

	func convertPixelBuffer(_ image: UIImage) -> CVPixelBuffer? {

		// Convert image to grey-scale pixel buffer
		let width = image.size.width
		let height = image.size.height
		var pixelBuffer : CVPixelBuffer?
		let attributes = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]

		let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(width), Int(height), kCVPixelFormatType_OneComponent8, attributes as CFDictionary, &pixelBuffer)

		guard status == kCVReturnSuccess, let imageBuffer = pixelBuffer else {
			return nil
		}

		CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

		let imageData =  CVPixelBufferGetBaseAddress(imageBuffer)
		guard let context = CGContext(data: imageData,
									  width: Int(width),
									  height: Int(height),
									  bitsPerComponent: 8,
									  bytesPerRow: CVPixelBufferGetBytesPerRow(imageBuffer),
									  space: CGColorSpaceCreateDeviceGray(),
									  bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
										return nil
		}

		context.translateBy(x: 0, y: CGFloat(height))
		context.scaleBy(x: 1, y: -1)

		UIGraphicsPushContext(context)
		image.draw(in: CGRect(x:0, y:0, width: width, height: height) )
		UIGraphicsPopContext()
		CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

		return imageBuffer
	}

	func convertImageData(_ buffer: CVPixelBuffer) -> Data? {

		// Convert pixel buffer to image data
		CVPixelBufferLockBaseAddress(buffer, .readOnly)
		defer {
			CVPixelBufferUnlockBaseAddress(buffer, .readOnly)
		}

		guard let sourceData = CVPixelBufferGetBaseAddress(buffer) else {
			return nil
		}

		let width = CVPixelBufferGetWidth(buffer)
		let height = CVPixelBufferGetHeight(buffer)
		let sourceBytesPerRow = CVPixelBufferGetBytesPerRow(buffer)

		let sourceBuffer = vImage_Buffer(data: sourceData,
										 height: vImagePixelCount(height),
										 width: vImagePixelCount(width),
										 rowBytes: sourceBytesPerRow)

		let byteData = Data(bytes: sourceBuffer.data, count: sourceBuffer.rowBytes * height)

		// Convert image data to floats
		let bytes = Array<UInt8>(byteData)
		var floats = [Float]()
		for i in 0..<bytes.count {
			floats.append(Float(bytes[i]) / 255.0)
		}

		return floats.withUnsafeBufferPointer(Data.init)
	}
}

// MARK: - Private methods

extension BAProcessImageService {

	private func cropRoiSquare(_ image: UIImage,
							   _ roiSizeLength: CGFloat) -> UIImage? {

		// Crop the ROI square of the image
		guard let cgImage = image.cgImage else {
			return nil
		}

		let x = ((CGFloat(cgImage.width) - roiSizeLength) / 2).rounded()
		let y = ((CGFloat(cgImage.height) - roiSizeLength) / 2).rounded()

		let cropRect = CGRect(x: x, y: y, width: roiSizeLength, height: roiSizeLength)
		if let croppedCgImage = cgImage.cropping(to: cropRect) {
			return UIImage(cgImage: croppedCgImage,
						   scale: 0,
						   orientation: image.imageOrientation)
		}

		return nil
	}

	private func resizeImage(_ image: UIImage,
							 _ resizedSideLength: CGFloat) -> UIImage? {

		// Resize the image
		let resizedSize = CGSize(width: resizedSideLength,
								 height: resizedSideLength)

		UIGraphicsBeginImageContextWithOptions(resizedSize, true, 1.0)

		let resizedRect = CGRect(x: 0, y: 0,
								 width: resizedSideLength,
								 height: resizedSideLength)

		image.draw(in: resizedRect)

		guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
			UIGraphicsEndImageContext()
			return nil
		}

		UIGraphicsEndImageContext()
		return resizedImage
	}

	private func saveImageFile(_ image: UIImage) {

		// Save image file for debugging purpose
		let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(BAProcessImageServiceConstants.IMAGE_DIRECTORY_PATH)

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
		
		let imageData = image.jpegData(compressionQuality: BAProcessImageServiceConstants.IMAGE_COMPRESSION_QUALITY)
		if !FileManager.default.createFile(atPath: urlString as String,
										   contents: imageData,
										   attributes: nil) {
			BALogger.warn("Fail to save to image path: \(urlString)")
		}
	}
}

// MARK: - BAService

extension BAProcessImageService: BAService {

	var identifier: String {
		return String(describing: BAProcessImageService.self)
	}
}

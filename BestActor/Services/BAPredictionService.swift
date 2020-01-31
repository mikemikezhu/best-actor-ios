//
//  BAPredictionService.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/18/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import UIKit
import CoreML
import Vision

fileprivate struct BAPredictionServiceConstants {

	static let IMAGE_DIRECTORY_PATH = "images"
	static let IMAGE_COMPRESSION_QUALITY: CGFloat = 0.5
}

class BAPredictionService: NSObject {

	func predictFacialExpression(_ image: UIImage,
								 _ label: String,
								 _ completion: @escaping (_ result: Float?, _ error: Error?) -> Void) throws {

		// Detect face in the image
		let normalizedImage = image.fixOrientation()
		guard let faceImage = OpenCVWrapper.detectFace(normalizedImage) else {
			BALogger.error("Fail to detect any face in the image")
			completion(nil, BAError.failToDetectFace)
			return
		}

		#if DEBUG
		// Save face image for debugging purpose
		saveImageFile(faceImage)
		#endif

		if #available(iOS 13.0, *) {
			try makePrediction(image,
							   label,
							   completion)
		} else {

			// TODO: For debug purpose only, shall removed later
			if label == "happy" {
				completion(98.0, nil)
			} else if label == "sad" {
				completion(99.0, nil)
			} else if label == "surprise" {
				completion(96.0, nil)
			}
		}
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

	@available(iOS 13.0, *)
	private func makePrediction(_ image: UIImage,
								_ label: String,
								_ completion: @escaping (_ result: Float?, _ error: Error?) -> Void) throws {

		let model = try VNCoreMLModel(for: BAModel().model)
		let request = VNCoreMLRequest(model: model, completionHandler: { request, error in

			DispatchQueue.main.async {
				guard let results = request.results else {
					completion(nil, error)
					return
				}

				for result in results {
					if let result = result as? VNClassificationObservation,
						let modelLabel = BAModelLabelConverter.convertModelLabel(label) {

						if modelLabel == result.identifier {
							completion(result.confidence, nil)
							return
						}
					}
				}

				completion(nil, BAError.failToPredict)
			}
		})

		request.imageCropAndScaleOption = .scaleFill

		DispatchQueue.global(qos: .userInitiated).async {
			if let ciImage = CIImage(image: image) {
				let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
				do {
					try handler.perform([request])
				} catch {
					completion(nil, BAError.failToPredict)
				}
			}
		}
	}
}

// MARK: - BAService

extension BAPredictionService: BAService {

	var identifier: String {
		return String(describing: BAPredictionService.self)
	}
}

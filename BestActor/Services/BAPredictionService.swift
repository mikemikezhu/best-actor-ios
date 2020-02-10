//
//  BAPredictionService.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/18/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import CoreImage
import TensorFlowLite
import UIKit

fileprivate struct BAPredictionServiceConstants {

	// Model: FER2013.tflite
	static let MODEL_INFO_FILE_NAME = "FER2013"
	static let MODEL_INFO_FILE_EXTENSION = "tflite"

	// Labels: labels.txt
	static let LABELS_INFO_FILE_NAME = "labels"
	static let LABELS_INFO_FILE_EXTENSION = "txt"
}

fileprivate struct BAInference {

	let confidence: Float
	let label: String
}

class BAPredictionService {
	
	// MARK: - Private Properties
	
	private var labels: [String] = []
	private var interpreter: Interpreter
	private var processImageService: BAProcessImageService
	
	// MARK: - Initialize
	
	init(_ processImageService: BAProcessImageService) {
		
		// Construct the path to the model file
		guard let modelPath = Bundle.main.path(forResource: BAPredictionServiceConstants.MODEL_INFO_FILE_NAME,
											   ofType: BAPredictionServiceConstants.MODEL_INFO_FILE_EXTENSION) else {
												fatalError("Failed to load the model file with name: \(BAPredictionServiceConstants.MODEL_INFO_FILE_NAME).")
		}
		
		// Specify the options for the `Interpreter`
		let options = Interpreter.Options()
		do {
			// Create the `Interpreter`.
			interpreter = try Interpreter(modelPath: modelPath, options: options)
			// Allocate memory for the model's input `Tensor`s.
			try interpreter.allocateTensors()
		} catch let error {
			fatalError("Failed to create the interpreter with error: \(error.localizedDescription)")
		}
		
		// Load the classes listed in the labels file
		guard let fileURL = Bundle.main.url(forResource: BAPredictionServiceConstants.LABELS_INFO_FILE_NAME,
											withExtension: BAPredictionServiceConstants.LABELS_INFO_FILE_EXTENSION) else {
												fatalError("Labels file not found in bundle. Please add a labels file with name " +
													"\(BAPredictionServiceConstants.LABELS_INFO_FILE_NAME) and try again.")
		}
		
		do {
			let contents = try String(contentsOf: fileURL, encoding: .utf8)
			labels = contents.components(separatedBy: .newlines)
		} catch {
			fatalError("Labels file named \(BAPredictionServiceConstants.LABELS_INFO_FILE_NAME) cannot be read. Please add a " +
				"valid labels file and try again.")
		}
		
		// Set process image service
		self.processImageService = processImageService
	}
	
	// MARK: - Internal methods
	
	func predictFacialExpression(_ image: UIImage,
								 _ label: String,
								 _ completion: @escaping (_ result: Float?, _ error: Error?) -> Void) {
		
		// Process the image
		let width = UIScreen.main.bounds.size.width
		let screenScale = UIScreen.main.scale
		let roiSideLength = CGFloat(BAGlobalConstants.ROI_SIDE_FACTOR) * width * screenScale
		BALogger.info("Square ROI side length: \(roiSideLength)")

		let resizedSideLength = CGFloat(BAGlobalConstants.RESIZED_SIDE_LENGTH)
		guard let processedImage = processImageService.processImage(image, roiSideLength, resizedSideLength) else {
			BALogger.error("Fail to process image")
			completion(nil, BAError.failToProcessImage)
			return
		}

		// Convert pixel buffer
		guard let pixelBuffer = processImageService.convertPixelBuffer(processedImage) else {
			BALogger.error("Fail to get pixel buffer of image")
			completion(nil, BAError.failToProcessImage)
			return
		}

		// Run computer vision model and make predictions
		DispatchQueue.global(qos: .userInitiated).async {
			
			guard let inferences = self.runModel(onFrame: pixelBuffer) else {
				
				DispatchQueue.main.async {
					BALogger.error("Fail to make predictions")
					completion(nil, BAError.failToPredict)
				}
				return
			}
			
			DispatchQueue.main.async {

				BALogger.info("Predictions: \(inferences)")
				for inference in inferences {
					if inference.label == label {
						let confidence = inference.confidence
						BALogger.info("Facial expression \(label): \(confidence)")
						completion(confidence, nil)
						return
					}
				}
			}
		}
	}
}

// MARK: - Private methods

extension BAPredictionService {

	private func runModel(onFrame pixelBuffer: CVPixelBuffer) -> [BAInference]? {

		// Run computer vision model and make predictions
		let outputTensor: Tensor
		do {
			// Get the image data from pixel buffer
			guard let imageData = processImageService.convertImageData(pixelBuffer) else {
				print("Failed to convert the image buffer to RGB data.")
				return nil
			}

			// Copy the image data to the input `Tensor`.
			try interpreter.copy(imageData, toInputAt: 0)

			// Run inference by invoking the `Interpreter`.
			try interpreter.invoke()

			// Get the output `Tensor` to process the inference results.
			outputTensor = try interpreter.output(at: 0)

		} catch let error {
			BALogger.error("Failed to invoke the interpreter with error: \(error.localizedDescription)")
			return nil
		}

		let results: [Float]
		switch outputTensor.dataType {
		case .uInt8:
			guard let quantization = outputTensor.quantizationParameters else {
				BALogger.error("No results returned because the quantization values for the output tensor are nil.")
				return nil
			}
			let quantizedResults = [UInt8](outputTensor.data)
			results = quantizedResults.map {
				quantization.scale * Float(Int($0) - quantization.zeroPoint)
			}
		case .float32:
			let data = outputTensor.data
			results = data.withUnsafeBytes { .init($0.bindMemory(to: Float.self)) }
		default:
			BALogger.error("Output tensor data type \(outputTensor.dataType) is unsupported for this example app.")
			return nil
		}

		// Return the inference time and inference results.
		let zippedResults = zip(results, labels.indices)
		let inferences = zippedResults.map { result in BAInference(confidence: result.0, label: labels[result.1]) }

		return inferences
	}
}


// MARK: - BAService

extension BAPredictionService: BAService {
	
	var identifier: String {
		return String(describing: BAPredictionService.self)
	}
}

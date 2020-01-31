//
//  OpenCVWrapper.mm
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

#ifdef __cplusplus
#include <opencv2/opencv.hpp>
#endif

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#include <opencv2/core/utils/logger.hpp>

#import "OpenCVWrapper.h"

static NSString *const OPENCV_WRAPPER_HAAR_CASCADE_FRONTAL_FACE = @"haarcascade_frontalface_default";
static NSString *const OPENCV_WRAPPER_HAAR_CASCADE_FRONTAL_FACE_TYPE = @"xml";

static const double OPENCV_WRAPPER_SCALING_FACTOR = 1.1;
static const int OPENCV_WRAPPER_MIN_NEIGHBORS = 3;
static const int OPENCV_WRAPPER_FLAGS = 0;

static const double OPENCV_WRAPPER_MIN_SIZE = 160;
static const double OPENCV_WRAPPER_MAX_SIZE = 900;

@implementation OpenCVWrapper

+ (NSString *)versionNumber {
	return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

+ (UIImage *)detectFace:(UIImage *)image {

	// Convert UIImage to CV Mat
	cv::Mat colorMat;
	UIImageToMat(image, colorMat);

	// Convert to grayscale
	cv::Mat grayMat;
	cv::cvtColor(colorMat, grayMat, cv::COLOR_BGR2GRAY);

	// Load detector from file
	cv::CascadeClassifier classifier;
	const NSString* cascadePath = [[NSBundle mainBundle] pathForResource:OPENCV_WRAPPER_HAAR_CASCADE_FRONTAL_FACE
																  ofType:OPENCV_WRAPPER_HAAR_CASCADE_FRONTAL_FACE_TYPE];
	classifier.load([cascadePath UTF8String]);

	// Initialize vars for classifier
	const cv::Size minimumSize(OPENCV_WRAPPER_MIN_SIZE, OPENCV_WRAPPER_MIN_SIZE);
	const cv::Size maximumSize(OPENCV_WRAPPER_MAX_SIZE, OPENCV_WRAPPER_MAX_SIZE);

	// Classify functions
	std::vector<cv::Rect> detections;
	std::vector<int> rejectLevels;
	std::vector<double> levelWeights;

	classifier.detectMultiScale(grayMat,
								detections,
								rejectLevels,
								levelWeights,
								OPENCV_WRAPPER_SCALING_FACTOR,
								OPENCV_WRAPPER_MIN_NEIGHBORS,
								OPENCV_WRAPPER_FLAGS,
								minimumSize,
								maximumSize,
								true);

	// If no detections found, return nil
	if (detections.size() <= 0) {
		CV_LOG_WARNING(NULL, "Fail to detect face");
		return nil;
	}

	// Loop to find the most confident detections
	double maxWeight = 0;
	std::map<double, cv::Rect> faces;

	for (int i = 0; i < detections.size(); i++) {
		
		cv::Rect face = detections[i];
		double weight = levelWeights[i];

		if (weight > maxWeight) {
			faces[weight] = face;
			maxWeight = weight;
		}
	}

	// Crop the image
	cv::Rect maxFace = faces[maxWeight];
	cv::Mat roi = grayMat(maxFace);

	cv::Mat destination;
	cv::resize(roi, destination, cv::Size(48, 48));

	CV_LOG_INFO(NULL, "Successfully detect face");
	return MatToUIImage(destination);
}

@end

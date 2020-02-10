//
//  BAError.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/1/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import Foundation

enum BAError: Error {
	case failToProcessImage
	case failToPredict
}

extension BAError: LocalizedError {

	var errorDescription: String? {
		switch self {
		case .failToProcessImage:
			return NSLocalizedString("Fail to process face image", comment: "")
		case .failToPredict:
			return NSLocalizedString("Fail to predict model", comment: "")
		}
	}
}

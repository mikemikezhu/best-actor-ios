//
//  BAError.swift
//  BestActor
//
//  Created by Mike's Macbook on 2020/1/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import Foundation

enum BAError: Error {
	case failToDetectFace
	case failToPredict
}

extension BAError: LocalizedError {

	var errorDescription: String? {
		switch self {
		case .failToDetectFace:
			return NSLocalizedString("Fail to detect face", comment: "")
		case .failToPredict:
			return NSLocalizedString("Fail to predict model", comment: "")
		}
	}
}

//
//  Date+CustomDate.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/18/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import Foundation

extension Date {

	private static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
	private static var dateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = Date.dateFormat
		formatter.locale = Locale.current
		formatter.timeZone = TimeZone.current
		return formatter
	}

	func toString() -> String {
		return Date.dateFormatter.string(from: self as Date)
	}
}

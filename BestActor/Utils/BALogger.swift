//
//  BALogger.swift
//  BestActor
//
//  Created by Mike's Macbook on 1/17/20.
//  Copyright © 2020 Mikemikezhu. All rights reserved.
//

import Foundation

enum LogEvent: String {
	case info = "INFO"
	case error = "ERROR"
	case warn = "WARN"
}

class BALogger {

	class func info(_ object: Any,
					filePath: String = #file,
					line: Int = #line,
					method: String = #function) {

		let date = Date().toString()
		let event = LogEvent.info.rawValue
		let source = extractSourceFile(filePath)

		print("\(date) [\(event)] - \(source) [Line \(line)] - \(method): \(object)")
	}

	class func error(_ object: Any,
					 filePath: String = #file,
					 line: Int = #line,
					 method: String = #function) {

		let date = Date().toString()
		let event = LogEvent.error.rawValue
		let source = extractSourceFile(filePath)

		print("\(date) [\(event)] - \(source) [Line \(line)] - \(method): \(object)")
	}

	class func warn(_ object: Any,
					filePath: String = #file,
					line: Int = #line,
					method: String = #function) {

		let date = Date().toString()
		let event = LogEvent.warn.rawValue
		let source = extractSourceFile(filePath)

		print("\(date) [\(event)] - \(source) [Line \(line)] - \(method): \(object)")
	}

	private class func extractSourceFile(_ filePath: String) -> String {
		let components = filePath.components(separatedBy: "/")
		return components.isEmpty ? "" : components.last!
	}
}

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

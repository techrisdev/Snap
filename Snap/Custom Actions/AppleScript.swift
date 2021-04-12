// AppleScript.swift
//
// Created by TeChris on 12.03.21.

import AppKit

class AppleScript {
	private var script: String
	
	/// Initialize the class with a script.
	init(script: String) {
		self.script = script
	}
	
	private var errorInfo: NSDictionary?
	
	/// Execute an Apple Script which automatically tells System Events the provided string.
	static func executeByTellingSystemEvents(string: String) {
		// Create an Apple Script.
		let appleScript = AppleScript(script: "tell application \"System Events\"\n\(string)\nend tell")
		
		// If an error occured, then show the failure alert.
		let error = appleScript.execute()
		if error != nil {
			appleScript.failureAlert.runModal()
		}
	}
	
	func execute() -> NSDictionary? {
		let nsAppleScript = NSAppleScript(source: script)
		
		var errorInfo: NSDictionary?
		
		// Execute the NSAppleScript.
		nsAppleScript?.executeAndReturnError(&errorInfo)
		
		self.errorInfo = errorInfo
		
		// Return the error info.
		return errorInfo
	}
	
	private var failureAlert: NSAlert {
		// If error is nil, then throw a fatal error.
		guard let errorInfo = errorInfo else { fatalError("There is no error.") }
		let alert = NSAlert()
		alert.messageText = "Apple Script failure"
		alert.informativeText = "Something went wrong :(\n\nError: \(errorInfo)"

		// Return the new alert.
		return alert
	}
}

// ActionSearchItem.swift
//
// Created by TeChris on 09.03.21.

import Foundation

struct ActionSearchItem: SearchItem, Codable {
	var id = UUID()
	
	var title: String
	
	var appleScript: String
	
	var action: (String) -> Void {
		return { arguments in
			let appleScriptWithArguments = appleScript.replacingOccurrences(of: "\\arguments\\", with: "\(arguments)")
			AppleScript.executeByTellingSystemEvents(string: appleScriptWithArguments)
		}
	}
	
	var acceptsArguments = true
	
	private enum CodingKeys: CodingKey {
		case title
		case appleScript
	}
}

// Actions.swift
//
// Created by TeChris on 10.03.21.

import Cocoa

/// Different actions that can be executed by the application.
struct Actions {
	static func getAction(for action: Action) -> (String) -> Void {
		switch action {
		case .sleep:
			return sleep
		case .restart:
			return restart
		case .shutdown:
			return sleep
		case .term:
			return term
		}
	}
	
	static var sleep: (String) -> Void = { _ in
		let string = "sleep"
		AppleScript.executeByTellingSystemEvents(string: string)
	}
	
	static var restart: (String) -> Void = { _ in
		let string = "restart"
		AppleScript.executeByTellingSystemEvents(string: string)
	}
	
	static var shutdown: (String) -> Void = { _ in
		let string = """
		tell application \"Finder\"
		shut down
		end tell
		"""
		AppleScript.executeByTellingSystemEvents(string: string)
	}
	
	static var term: (String) -> Void = { command in
		let string = """
		tell application "Terminal"
		activate
		do script ("\(command)") in window 1
		end tell
		"""
		AppleScript.executeByTellingSystemEvents(string: string)
	}
}

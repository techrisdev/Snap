// TypingWindow.swift
//
// Created by TeChris on 08.03.21.

import Cocoa

/// A window that accepts Key Events and posts a Notification when the text changes.
class TypingWindow: NSWindow {
	/// The window's current string.
	var text = "" {
		didSet {
			// Post a notification.
			NotificationCenter.default.post(name: .TextChanged, object: nil)
		}
	}
	
	/// The arguments after the search string.
	var currentSearchArguments: String {
		let textSplitBySpaces = text.components(separatedBy: .whitespaces)
		
		if textSplitBySpaces.indices.contains(1) {
								// Drop the search item.
			let argumentArray = textSplitBySpaces.dropFirst()
			
			var result = ""
			
			// Go through the arguments.
			for argument in argumentArray {
				// If the argument isn't the first argument, then append a space to the string.
				if !result.isEmpty {
					result.append(" ")
				}
				
				// Append the argument.
				result.append(argument)
			}
			
			return result
		}
		
		// If the search doesn't contain an argument, then return an empty string.
		return ""
	}
	
	override func keyDown(with event: NSEvent) {
		// The delete key was pressed.
		if event.keyCode == 51 {
			// If the string is not empty, then remove the last character.
			if !text.isEmpty {
				text.removeLast()
			}
			
			// Return from the function.
			return
		}
		
		// The Up-Arrow key was pressed.
		if event.keyCode == 126 {
			// Post a notification.
			NotificationCenter.default.post(name: .UpArrowKeyWasPressed, object: nil)
			
			// Return from the function.
			return
		}
		
		// The Down-Arrow key was pressed.
		if event.keyCode == 125 {
			// Post a notification.
			NotificationCenter.default.post(name: .DownArrowKeyWasPressed, object: nil)
			
			// Return from the function.
			return
		}
		
		// The tab key was pressed.
		if event.keyCode == 48 {
			// Post a notification.
			NotificationCenter.default.post(name: .TabKeyWasPressed, object: nil)
			
			// Return from the function.
			return
		}
		
		// Get the event's characters.
		let characters = event.charactersIgnoringModifiers ?? ""
		
		// The return key was pressed.
		if characters == "\r" {
			// Post a notification.
			NotificationCenter.default.post(name: .ReturnKeyWasPressed, object: nil)
			
			// Return from the function.
			return
		}
		
		// Append the new character.
		text.append(characters)
	}
}

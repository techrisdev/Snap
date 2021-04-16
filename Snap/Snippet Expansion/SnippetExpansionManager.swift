// SnippetExpansionManager.swift
//
// Created by TeChris on 14.04.21.

import Carbon.HIToolbox.Events
import AppKit.NSEvent

struct SnippetExpansionManager {
	/// The configured snippets.
	private let snippets = Configuration.decoded.snippets
	
	/// Start listening to keywords.
	func start() {
		// If the app doesn't have Accessibility permissions, return from the function (they are needed).
		if !AXIsProcessTrusted() {
			return
		}
		
		// The current word.
		var currentWord = ""
		
		// Listen to "keyDown" events.
		NSEvent.addGlobalMonitorForEvents(matching: .keyDown, handler: { event in
			// Check if the event has a character.
			guard let firstCharacter = event.charactersIgnoringModifiers?.first else { return }
			
			// Reference: https://stackoverflow.com/a/35539257
			// Note: You probably could also use the key code here.
			// If the delete key was pressed, remove the last character and return.
			if firstCharacter == Character(UnicodeScalar(NSDeleteCharacter)!) {
				// Check if the word doesn't contain any characters.
				if !currentWord.isEmpty {
					currentWord.removeLast()
				}
				
				return
			}
			
			// If the first character isn't a letter, a number, a symbol or a punctation, then reset the current word.
			if !(firstCharacter.isLetter || firstCharacter.isNumber || firstCharacter.isSymbol || firstCharacter.isPunctuation) {
				currentWord = ""
				return
			}
			
			// If there is a normal character, then append it. (Unwrapping again, because there can be more than one character. I've never seen that happen, but to be sure...)
			if let characters = event.charactersIgnoringModifiers {
				currentWord.append(characters)
			}
			
			// Go through all the snippets to check if a keyword was typed.
			for snippet in snippets {
				if currentWord == snippet.keyword {
					// If a keyword was typed, write the snippet.
					// Delete all typed characters (the keyword).
					for _ in snippet.keyword {
						// Delete the character.
						let event = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(kVK_Delete), keyDown: true)
						event!.post(tap: .cghidEventTap)
						let event2 = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(kVK_Delete), keyDown: false)
						event2!.post(tap: .cghidEventTap)
					}
					
					// Get the UTF16 characters from the string.
					let utf16Chars = Array(snippet.snippet.utf16)
					
					// Write the string.
					let event1 = CGEvent(keyboardEventSource: nil, virtualKey: .zero, keyDown: true);
					event1?.flags = .maskNonCoalesced
					event1?.keyboardSetUnicodeString(stringLength: utf16Chars.count, unicodeString: utf16Chars)
					event1?.post(tap: .cghidEventTap)

					let event2 = CGEvent(keyboardEventSource: nil, virtualKey: .zero, keyDown: false);
					event2?.flags = .maskNonCoalesced
					event2?.post(tap: .cghidEventTap)
					
					// Reset the current word.
					currentWord = ""
					
					// Return from the function.
					return
				}
			}
		})
	}
}

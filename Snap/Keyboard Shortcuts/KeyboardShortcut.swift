// KeyboardShortcut.swift
//
// Created by TeChris on 11.03.21.

import Carbon.HIToolbox.Events

struct KeyboardShortcut: Codable {
	/// The shortcut's key.
	var key: Key
	
	/// The keyboard shortcut modifiers.
	var modifiers: [KeyboardShortcutModifier]
	
	/// The events the shortcut is listening to.
	var events: [KeyEvent]
	
	/// The shortcut's modifiers as carbon modifiers.
	var carbonModifiers: UInt32 {
		var result = 0
		
		if modifiers.contains(.command) {
			result += cmdKey
		}
		
		if modifiers.contains(.option) {
			result += optionKey
		}
		
		if modifiers.contains(.control) {
			result += controlKey
		}
		
		if modifiers.contains(.shift) {
			result += shiftKey
		}
		
		return UInt32(result)
	}
	
	/// The shortcut's ID.
	var id: UInt32 {
		// Create an ID from the key code and modifiers.
		let id = key.keyCode + carbonModifiers
		return id
	}
}

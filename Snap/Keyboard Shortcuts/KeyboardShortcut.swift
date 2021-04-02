// KeyboardShortcut.swift
//
// Created by TeChris on 11.03.21.

import Cocoa
import Carbon.HIToolbox.Events

struct KeyboardShortcut: Codable {
	/// The shortcut's key code.
	var keyCode: UInt32
	
	/// The shortcut's modifiers.
	var carbonModifiers: UInt32
	
	/// The events the shortcut is recognizing.
	var events: [KeyEvent]
	
	private init(keyCode: Int, carbonModifiers: Int, events: [KeyEvent]) {
		self.keyCode = UInt32(keyCode)
		self.carbonModifiers = UInt32(carbonModifiers)
		self.events = events
	}
	
	init(keyCode: Int, modifierFlags: NSEvent.ModifierFlags, events: [KeyEvent]) {
		let carbonModifiers = KeyboardShortcut.getCarbonModifiers(for: modifierFlags)
		self.init(keyCode: keyCode, carbonModifiers: carbonModifiers, events: events)
	}
	
	/// Convert NSEvent modifier flags to carbon modifiers.
	static func getCarbonModifiers(for modifiers: NSEvent.ModifierFlags) -> Int {
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
		
		return result
	}
	
	/// The shortcut's ID.
	var id: UInt32 {
		// Create an ID from the key code and modifiers.
		let id = keyCode + carbonModifiers
		return id
	}
}

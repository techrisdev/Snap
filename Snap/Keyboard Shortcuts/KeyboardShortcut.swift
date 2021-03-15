// KeyboardShortcut.swift
//
// Created by TeChris on 11.03.21.

import Carbon
import Cocoa

struct KeyboardShortcut {
	/// The shortcut's key code.
	var keyCode: UInt32
	
	/// The shortcut's modifiers.
	var modifiers: UInt32
	
	/// The events the shortcut is recognizing.
	var events: [KeyEvent]
	
	init(keyCode: Int, modifiers: Int, events: [KeyEvent]) {
		self.keyCode = UInt32(keyCode)
		self.modifiers = UInt32(modifiers)
		self.events = events
	}
	
	init(keyCode: Int, modifierFlags: NSEvent.ModifierFlags, events: [KeyEvent]) {
		let carbonModifiers = KeyboardShortcut.getCarbonModifiers(for: modifierFlags)
		self.init(keyCode: keyCode, modifiers: carbonModifiers, events: events)
	}
	
	/// Convert NSEvent modifier flags to carbon modifiers.
	private static func getCarbonModifiers(for modifiers: NSEvent.ModifierFlags) -> Int {
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
		let id = keyCode + modifiers
		return id
	}
}
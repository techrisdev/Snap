// NSEventModifierFlags Extension.swift
//
// Created by TeChris on 10.04.21.

import AppKit.NSEvent

extension NSEvent.ModifierFlags {
	var keyboardShortcutModifiers: [KeyboardShortcutModifier] {
		var result = [KeyboardShortcutModifier]()
		
		if self.contains(.command) {
			result.append(.command)
		}
		
		if self.contains(.option) {
			result.append(.option)
		}
		
		if self.contains(.control) {
			result.append(.control)
		}
		
		if self.contains(.shift) {
			result.append(.shift)
		}
		
		return result
	}
}

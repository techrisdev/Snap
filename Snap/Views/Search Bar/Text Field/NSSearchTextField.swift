// NSSearchTextField.swift
//
// Created by TeChris on 03.04.21.

import AppKit

/// A custom NSTextField.
class NSSearchTextField: NSTextField {
	func setFont(_ font: NSFont) {
		// Set the text field's font.
		super.font = font
	}
	
	override var font: NSFont? {
		get {
			return super.font
		}
		set {
			// The font for some reason gets set automatically, that's why the setter does nothing.
		}
	}
}

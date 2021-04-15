// FontPicker.swift
//
// Created by TeChris on 02.04.21.

import SwiftUI

@objc class FontPicker: NSObject {
	@Binding var font: Font
	
	/// Initialize the class.
	init(font: Binding<Font>) {
		_font = font
	}
	
	/// The font manager.
	private var fontManager = NSFontManager.shared

	func open() {
		// Set the font manager's target.
		fontManager.target = self
		
		// Set the font manager's action.
		fontManager.action = #selector(onFontChange)
		
		// Create a font panel.
		let panel = fontManager.fontPanel(true)
		
		// Present the panel.
		panel?.makeKeyAndOrderFront(nil)
	}
	
	let nsFont = NSFont.systemFont(ofSize: 12)
	
	@objc private func onFontChange() {
		// Get the font manager's current font.
		let newFont = fontManager.convert(nsFont)
		
		// Update the font.
		self.font = Font(nsFont: newFont)
	}
}

// Font.swift
//
// Created by TeChris on 02.04.21.

import Cocoa

struct Font: Codable {
	/// The font converted to a NSFont.
	var nsFont: NSFont {
		guard let font = NSFont(name: name, size: size) else { return NSFont() }
		return font
	}
	
	/// Initialize the structure.
	init(name: String, size: CGFloat) {
		self.name = name
		self.size = size
	}
	
	/// Initialize with a NSFont.
	init(nsFont: NSFont) {
		name = nsFont.displayName!
		size = nsFont.pointSize
	}
	
	var name: String
	var size: CGFloat
}

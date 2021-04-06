// String Extension.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

extension String {
	// This lets you subscript a String.
	subscript(idx: Int) -> String {
		String(self[index(startIndex, offsetBy: idx)])
	}
	
	public func firstCharacterCapitalized() -> String {
		let capitalizedFirstCharacter = self.first!.uppercased()
		let stringWithoutFirstCharacter = self.dropFirst()
		
		return capitalizedFirstCharacter + stringWithoutFirstCharacter
	}
	
	/// Converts a hex string to a SwiftUI color.
	var color: Color {
		// Remove the optional beginning (#, 0x) of a hex string.
		let hexString = self.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "0x", with: "")
		
		let scanner = Scanner(string: hexString)
		var resultInt: UInt64 = 0
		scanner.scanHexInt64(&resultInt)
		let red = CGFloat((resultInt & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((resultInt & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((resultInt & 0xFF)) / 255.0
		
		let nsColor = NSColor(red: red, green: green, blue: blue, alpha: 1.0)
		
		return Color(nsColor)
	}
}

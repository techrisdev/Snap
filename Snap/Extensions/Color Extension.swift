// Color Extension.swift
//
// Created by TeChris on 15.03.21.

import SwiftUI

extension Color {
	static func fromHexString(_ string: String) -> Color {
		var hexString = string
		hexString = hexString.replacingOccurrences(of: "#", with: "")
		hexString = hexString.replacingOccurrences(of: "0x", with: "")
		
		let scanner = Scanner(string: hexString)
		var resultInt: UInt64 = 0
		scanner.scanHexInt64(&resultInt)
		let red = CGFloat((resultInt & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((resultInt & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((resultInt & 0xFF)) / 255.0
		
		let nsColor = NSColor(red: red, green: green, blue: blue, alpha: 1.0)
		
		return Color(nsColor)
	}
	
	var hexString: String {
		let nsColor = NSColor(self).usingColorSpace(.deviceRGB)!
		
		let redComponent = Int(round(nsColor.redComponent * 0xFF))
		let greenComponent = Int(round(nsColor.greenComponent * 0xFF))
		let blueComponent = Int(round(nsColor.blueComponent * 0xFF))
		let hexString = NSString(format: "#%02X%02X%02X", redComponent, greenComponent, blueComponent)
		
		return hexString as String
	}
}

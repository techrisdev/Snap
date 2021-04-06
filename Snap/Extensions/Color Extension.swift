// Color Extension.swift
//
// Created by TeChris on 15.03.21.

import SwiftUI

extension Color {
	var hexString: String {
		guard let nsColor = NSColor(self).usingColorSpace(.deviceRGB) else {
			return "#FFFFFF"
		}
		
		let redComponent = Int(round(nsColor.redComponent * 0xFF))
		let greenComponent = Int(round(nsColor.greenComponent * 0xFF))
		let blueComponent = Int(round(nsColor.blueComponent * 0xFF))
		let hexString = NSString(format: "#%02X%02X%02X", redComponent, greenComponent, blueComponent)
		
		return hexString as String
	}
}

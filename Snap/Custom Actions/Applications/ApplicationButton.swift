// ApplicationButton.swift
//
// Created by TeChris on 04.04.21.

import SwiftUI

/// A button which uses the reversed configured colors so the user recognizes them as interactive.
struct ApplicationButton<Label> : View where Label : View {
	var action: () -> Void
	var frame: NSSize = NSSize(width: 30, height: 25)
	var label: () -> Label
	// The color is reversed: Here, the foreground color is the background color.
	private let foregroundColor = Configuration.decoded.backgroundColor.color
	
	// Here, the color is reversed as well.
	private let backgroundColor = Configuration.decoded.textColor.color
	var body: some View {
		Button(action: action) {
			ZStack {
				backgroundColor
					// Apply a corner radius to the background.
					.cornerRadius(3)
				label()
					.foregroundColor(foregroundColor)
			}
		}
		.frame(width: frame.width, height: frame.height)
		.buttonStyle(PlainButtonStyle())
	}
}

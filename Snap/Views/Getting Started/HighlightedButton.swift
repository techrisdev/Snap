// HighlightedButton.swift
//
// Created by TeChris on 14.04.21.

import SwiftUI

/// A button with a blue background color.
struct HighlightedButton: NSViewRepresentable {
	var title: String
	var action: () -> Void
	
	init(_ title: String, action: @escaping () -> Void) {
		self.title = title
		self.action = action
	}
	
	func makeNSView(context: Context) -> some NSView {
		// Configure the button.
		let button = NSButton(title: title, target: context.coordinator, action: #selector(context.coordinator.buttonAction))
		button.isHighlighted = true
		
		// Return the new view.
		return button
	}
	
	func updateNSView(_ nsView: NSViewType, context: Context) {
		
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(action: action)
	}
	
	class Coordinator {
		private var action: () -> Void
		
		init(action: @escaping () -> Void) {
			self.action = action
		}
		
		@objc func buttonAction() {
			self.action()
		}
	}
}

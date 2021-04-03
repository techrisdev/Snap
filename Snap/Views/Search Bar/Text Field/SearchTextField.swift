// SearchTextField.swift
//
// Created by TeChris on 19.03.21.

import SwiftUI

struct SearchTextField: NSViewControllerRepresentable {
	@Binding var text: String
	
	func makeNSViewController(context: Context) -> some SearchTextFieldViewController {
		return SearchTextFieldViewController(text: $text)
	}
	
	func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
		let textField = nsViewController.textField
		textField?.stringValue = text
	}
}

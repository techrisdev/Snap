// TextField.swift
//
// Created by TeChris on 19.03.21.

import SwiftUI

struct SearchTextField: NSViewControllerRepresentable {
	@Binding var text: String
	
	func makeNSViewController(context: Context) -> some SearchTextFieldController {
		return SearchTextFieldController(text: $text)
	}
	
	func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
		let textField = nsViewController.textField
		textField?.stringValue = text
	}
}

class SearchTextFieldController: NSViewController, NSTextFieldDelegate {
	@Binding var text: String
	
	init(text: Binding<String>) {
		_text = text
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}

	var textField: NSSearchTextField!
	
	let configuration = Configuration.decoded
	
	lazy var textColor: NSColor = {
		let color = Color.fromHexString(configuration.textColor)
		return NSColor(color)
	}()

	lazy var font: NSFont = {
		// Return the font.
		return configuration.searchBarFont.nsFont
	}()
	
	override func loadView() {
		// Set up the text field.
		textField = NSSearchTextField()
		
		// Set up single line mode and scrolling.
		textField.usesSingleLineMode = true
		textField.cell?.isScrollable = true

		// Set the text field's delegate
		textField.delegate = self
		
		// Set an initial text value.
		textField.stringValue = text
		
		// Set the text field's placeholder.
		// MARK: TODO: The placeholder string is not centered.
//		textField.placeholderAttributedString = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor.withAlphaComponent(0.6)])
		
		// Configure the text field's text and colors.
		let backgroundColor = NSColor(.fromHexString(configuration.backgroundColor))
		textField.backgroundColor = backgroundColor
		textField.textColor = textColor
		textField.setFont(font)
		textField.isBordered = false
		textField.focusRingType = .none
		
		// Set the view to the new text field.
		view = textField
	}
	
	/// The field editor for the text field.
	lazy var fieldEditor: NSTextView = {
		// Get the text field's field editor.
		return textField.window?.fieldEditor(true, for: textField) as! NSTextView
	}()
	
	override func viewDidAppear() {
		// Make the view the first responder.
		view.window?.makeFirstResponder(view)
		
		// Change the insertion point color.
		fieldEditor.insertionPointColor = NSColor(.fromHexString(configuration.insertionPointColor))
		
		// Select all characters so the user can start typing.
		textField.selectText(nil)
	}
	
	func controlTextDidChange(_ obj: Notification) {
		// Get the text field's current string.
		text = textField.stringValue
	}
}

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

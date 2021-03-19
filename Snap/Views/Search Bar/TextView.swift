// TextView.swift
//
// Created by TeChris on 19.03.21.

import SwiftUI

struct TextView: NSViewControllerRepresentable {
	@Binding var text: String
	
	func makeNSViewController(context: Context) -> some NSViewController {
		return TextViewController(text: $text)
	}
	
	func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
		
	}
}

class TextViewController: NSViewController, NSTextViewDelegate {
	@Binding var text: String
	
	init(text: Binding<String>) {
		_text = text
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError()
	}
	
	override func loadView() {
		// Configure the text view.
		let textView = NSTextView()
		
		let configuration = Configuration.decoded
		let backgroundColor = Color.fromHexString(configuration.backgroundColor)
		let textColor = Color.fromHexString(configuration.textColor)
		let insertionPointColor = Color.fromHexString(configuration.insertionPointColor)
		let fontSize = configuration.searchBarFontSize
		
		textView.backgroundColor = NSColor(backgroundColor)
		textView.textColor = NSColor(textColor)
		textView.font = .systemFont(ofSize: fontSize)
		textView.insertionPointColor = NSColor(insertionPointColor)
		
		textView.delegate = self
		view = textView
	}
	
	override func viewDidAppear() {
		// Make the view the first responder.
		view.window?.makeFirstResponder(view)
		(view as! NSTextView).selectAll(nil)
	}
	
	func textDidChange(_ notification: Notification) {
		// Assign the current string to the binding.
		let textView = view as! NSTextView
		text = textView.string
	}
}

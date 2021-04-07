// ClipboardHistoryItem.swift
//
// Created by TeChris on 05.04.21.

import AppKit.NSPasteboard

struct ClipboardHistoryItem: Codable {
	let id = UUID()
	var data: Data
	
	/// Get an image from the item's data.
	var image: NSImage? {
		if let string = String(data: data, encoding: .utf8), let url = URL(string: string), let image = NSImage(contentsOf: url) {
			// The item is an image, return it.
			return image
		} else if let image = NSImage(data: data) {
			// If the image accepts the data directly (tiff or png format), then return it.
			return image
		}
		
		return nil
	}
	
	/// Get file contents from the item's data.
	var file: String? {
		if let path = String(data: data, encoding: .utf8), let url = URL(string: path), let file = try? String(contentsOf: url) {
			return file
		}
		
		return nil
	}
	
	/// Get a string from the item's data.
	var string: String? {
		// Normally, if a string gets copied, the first type in the types array is Rich Text format. That means, we need to convert the data to normal format so it gets displayed properly.
		if let attributedString = NSAttributedString(rtf: data, documentAttributes: nil) {
			return attributedString.string
		} else {
			// If the attributed string is nil, then return a normal string.
			let string = String(data: data, encoding: .utf8)
			return string
		}
	}
	
	enum CodingKeys: CodingKey {
		case data
	}
}

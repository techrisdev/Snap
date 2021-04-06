// ClipboardHistoryItem.swift
//
// Created by TeChris on 05.04.21.

import AppKit.NSPasteboard

struct ClipboardHistoryItem: Codable {
	let id = UUID()
	var data: Data
	
	// MARK: TODO: Only strings work right now.
	/// Get an image from the item's data.
	var image: NSImage? {
		if let path = String(data: data, encoding: .utf8), let image = NSImage(contentsOf: URL(fileURLWithPath: path)) {
			// The item is an image, return it.
			return image
		}
		
		return nil
	}
	
	// MARK: TODO: Only strings work right now.
	/// Get file contents from the item's data.
	var file: String? {
		if let path = String(data: data, encoding: .utf8), let file = try? String(contentsOfFile: path) {
			return file
		}
		
		return nil
	}
	
	var string: String? {
		// Check if the data is a string.
		guard let string = String(data: data, encoding: .utf8) else { return nil }
		return string
	}
	
	var type: NSPasteboard.PasteboardType {
		if image != nil {
			return .png
		} else {
			return .string
		}
	}
	
	enum CodingKeys: CodingKey {
		case data
	}
}

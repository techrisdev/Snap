// ClipboardHistory.swift
//
// Created by TeChris on 05.04.21.

import Foundation

struct ClipboardHistory: Codable {
	/// The decoded clipboard history.
	static var decoded: ClipboardHistory {
		return decode()
	}
	
	var items: [ClipboardHistoryItem]
	
	/// The URL to the clipboard history file.
	static private let url = Snap.applicationSupportURL.appendingPathComponent("ClipboardHistory.json")
	
	/// Decode the file containing the history.
	static func decode() -> ClipboardHistory {
		let fileManager = FileManager.default
		
		// Check if the file already exists.
		if !fileManager.fileExists(atPath: url.path) {
			// If the file doesn't exist, then create it to avoid crashes.
			fileManager.createFile(atPath: url.path, contents: "{\"items\":[]}".data(using: .utf8), attributes: nil)
		}
		
		// Get data from the file.
		guard let data = try? Data(contentsOf: url) else { fatalError("Failed to get data from URL \(url).") }
		
		// Decode the file.
		let decoder = JSONDecoder()
		guard let history = try? decoder.decode(ClipboardHistory.self, from: data) else { fatalError("Failed to decode clipboard history.") }
		
		return history
	}
	
	/// Write a file containing the history to the default path.
	func write() {
		let url = ClipboardHistory.url
		do {
			// Encode the history to JSON format.
			let encoder = JSONEncoder()
			let clipboardHistory = try encoder.encode(self)
			
			// Write the JSON string to the file.
			try clipboardHistory.write(to: url)
		} catch {
			// If the process failed, the app should crash.
			fatalError("Failed to write clipboard history to URL \(url).")
		}
	}
}

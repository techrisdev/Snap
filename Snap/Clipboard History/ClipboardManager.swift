// ClipboardManager.swift
//
// Created by TeChris on 05.04.21.

import AppKit

class ClipboardManager {
	/// Start listening for changes in the clipboard.
	func start() {
		listenToClipboardChanges()
	}
	
	private let pasteboard = NSPasteboard.general
	
	private var currentData = ClipboardHistory.decoded.items.last?.data ?? Data()
	
	private var history = ClipboardHistory.decoded
	
	private func listenToClipboardChanges() {
		DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.75, execute: { [pasteboard, updateHistory, listenToClipboardChanges] in
			// Check for changes.
			
			if let data = pasteboard.data(forType: .string) {
				if self.currentData != data {
					// Update the data.
					self.currentData = data
					
					// Update the history.
					self.history.items.insert(ClipboardHistoryItem(data: self.currentData), at: 0)
					updateHistory()
				}
			}
			listenToClipboardChanges()
		})
	}
	
	private func updateHistory() {
		// Write the new clipboard history to the default path.
		history.write()
	}
}

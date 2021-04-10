// ClipboardManager.swift
//
// Created by TeChris on 05.04.21.

import AppKit.NSPasteboard

class ClipboardManager {
	/// Start listening for changes in the clipboard.
	func start() {
		listenToClipboardChanges()
	}
	
	private let pasteboard = NSPasteboard.general
	
	private var currentData: Data? {
		ClipboardHistory.decoded.items.first?.data
	}
	
	private func listenToClipboardChanges() {
		DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2, execute: { [pasteboard, listenToClipboardChanges] in
			// Check for changes.
			if let types = pasteboard.types, types.count > 0 {
				// The first type from the types array should be the default type.
				let type = types[0]
				if let data = pasteboard.data(forType: type) {
					let newItem = ClipboardHistoryItem(data: data)
					if self.currentData != newItem.data {
						// Update the history.
						self.updateClipboardHistory(with: newItem)
					}
				}
			}
			listenToClipboardChanges()
		})
	}
	
	private func updateClipboardHistory(with item: ClipboardHistoryItem) {
		// Create a new history with the item.
		var history = ClipboardHistory.decoded
		history.items.insert(item, at: 0)
		
		if history.items.count >= Configuration.decoded.historyItemLimit {
			history.items.removeLast()
		}
		
		// Write the new clipboard history to the default path.
		history.write()
	}
}

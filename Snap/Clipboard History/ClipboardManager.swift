// ClipboardManager.swift
//
// Created by TeChris on 05.04.21.

import AppKit.NSPasteboard

class ClipboardManager {
	/// Start listening for changes in the clipboard.
	func start() {
		setUpKeyboardShortcuts()
		listenToClipboardChanges()
	}
	
	private let pasteboard = NSPasteboard.general
	
	private var currentData: Data? = ClipboardHistory.decoded.items.first?.data
	
	private func setUpKeyboardShortcuts() {
		// Set up the keyboard shortcut for merging items.
		KeyboardShortcutManager(keyboardShortcut: Configuration.decoded.mergeClipboardHistoryItemKeyboardShortcut).startListeningForEvents { _ in
			// Get the currently selected text.
			// Get the current applicaton.
			guard let frontmostApplication = NSWorkspace.shared.frontmostApplication else { return }
			let application = AXUIElementCreateApplication(frontmostApplication.processIdentifier)
			
			// Get the focused UIElement.
			var focusedUIElement: CFTypeRef?
			AXUIElementCopyAttributeValue(application, kAXFocusedUIElementAttribute as CFString, &focusedUIElement)
			
			// Get the selected text.
			if focusedUIElement == nil {
				return
			}
			
			var selectedText: CFTypeRef?
			AXUIElementCopyAttributeValue(focusedUIElement as! AXUIElement, kAXSelectedTextAttribute as CFString, &selectedText)
			
			if let text = selectedText as? String {
				self.merge(text)
			}
		}
	}
	
	/// Merge a new string and the last copied string.
	private func merge(_ string: String) {
		// Get the last copied item.
		guard let lastCopiedItem = ClipboardHistory.decoded.items.first else { return }
		
		// If the item isn't a string, return.
		if lastCopiedItem.string == nil {
			return
		}
		
		// Append the new string.
		guard let data = string.data(using: .utf8) else { return }
		let newItem = lastCopiedItem
		newItem.data.append(data)
		
		var history = ClipboardHistory.decoded
		
		// If the array isn't empty remove the first item.
		if !history.items.isEmpty {
			history.items.removeFirst()
		}
		
		// Insert the new item.
		history.items.insert(newItem, at: 0)
		
		// Write the history.
		history.write()
		
		// If the option is enbled, play a sound.
		if Configuration.decoded.itemMergedSoundEnabled {
			NSSound(named: "Purr")?.play()
		}
	}
	
	private func listenToClipboardChanges() {
		DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2) { [pasteboard, listenToClipboardChanges] in
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
		}
	}
	
	private func updateClipboardHistory(with item: ClipboardHistoryItem) {
		// Create a new history with the item.
		var history = ClipboardHistory.decoded
		history.items.insert(item, at: 0)
		
		if history.items.count >= Configuration.decoded.clipboardHistoryItemLimit {
			history.items.removeLast()
		}
		
		// Write the new clipboard history to the default path.
		history.write()
		
		// Update the current data.
		currentData = item.data
	}
}

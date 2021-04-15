// PreferencesWindow.swift
//
// Created by TeChris on 15.04.21.

import AppKit

/// A custom NSWindow that sends a notification when it closes.
class PreferencesWindow: NSWindow {
	private let notificationCenter = NotificationCenter.default
	
	static let preferencesWindowWillCloseNotification = Notification.Name("PreferencesWindowWillClose")
	
	override func close() {
		// Send a notification to notify the view that the window has close.
		notificationCenter.post(name: PreferencesWindow.preferencesWindowWillCloseNotification, object: nil)
	}
	
	override func performClose(_ sender: Any?) {
		// Send a notification to notify the view that the window will close.
		notificationCenter.post(name: PreferencesWindow.preferencesWindowWillCloseNotification, object: nil)
	}
	
	func closeWindow() {
		super.close()
	}
}

// AppDelegate.swift
//
// Created by TeChris on 08.03.21.

import Cocoa
import SwiftUI
import Carbon

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	// The application's window.
	var window: TypingWindow!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Request needed permissions
		Permissions.requestPermissions()
		
		// Open the search bar.
		openSearchWindow()
		
		// Setup the keyboard shortcuts.
		setupKeyboardShortcuts()
	}
	
	func openSearchWindow() {
		// Create the SwiftUI view that provides the window contents.
		let searchView = SearchView()
		
		// Create the window and set the content view.
		window = TypingWindow(
			contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
			styleMask: [.titled, .fullSizeContentView],
			backing: .buffered, defer: false)
		window.isReleasedWhenClosed = false
		window.center()
		window.backgroundColor = .clear
		window.level = .floating
		window.hasShadow = false
		window.contentView = NSHostingView(rootView: searchView)
		NSApp.activate(ignoringOtherApps: true)
		window.makeKeyAndOrderFront(nil)
		
		// The titled style mask must be removed after the window ordered the front; Otherwise, it will stay in the background.
		window.styleMask.remove(.titled)
	}
	
	func setupKeyboardShortcuts() {
		// Setup the shortcut for hiding and showing the search bar.
		KeyboardShortcutManager(keyboardShortcut: Configuration.decoded.activationKeyboardShortcut).startListeningForEvents { _ in
			if NSApp.isHidden {
				NSApp.activate(ignoringOtherApps: true)
			} else {
				// Before hiding, exit out of all running custom applications.
				NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
				NSApp.hide(nil)
			}
		}
	}
	
	func applicationDidResignActive(_ notification: Notification) {
		// When the application loses focus, then hide it.
		NSApp.hide(nil)
	}
}



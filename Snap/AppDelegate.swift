// AppDelegate.swift
//
// Created by TeChris on 08.03.21.

import Cocoa
import SwiftUI
import Carbon

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	// The menu bar status item.
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	// The menu of the status item.
	var menu: NSMenu!
	
	// The application's window.
	var window: TypingWindow!
	
	// The settings window.
	var settingsWindow: NSWindow!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Request needed permissions
		Permissions.requestPermissions()
		
		// Setup the status item.
		setupStatusItem()
		
		// Open the search bar.
		openSearchWindow()
		
		// Setup the keyboard shortcuts.
		setupKeyboardShortcuts()
	}
	
	func applicationDidResignActive(_ notification: Notification) {
		// When the application loses focus, then close the window.
		NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
		window.close()
	}
	
	func setupStatusItem() {
		// If the status item doesn't have a button, then return.
		guard let button = statusItem.button else { return }
		
		// Set up the button.
		button.title = "🔦"
		
		// Set up the menu for the status item.
		menu = NSMenu()
		let menuItems = [
			NSMenuItem(title: "Show Search Bar",
					   action: #selector(activate),
					   keyEquivalent: ""),
			NSMenuItem(title: "Show Settings",
					   action: #selector(showSettingsWindow),
					   keyEquivalent: ","),
			NSMenuItem.separator(),
			NSMenuItem(title: "Quit",
					   action: #selector(NSApp.terminate(_:)),
					   keyEquivalent: "q")]
		
		menu.items = menuItems
		statusItem.menu = menu
	}
	
	func openSearchWindow() {
		// Create the SwiftUI view that provides the window contents.
		let searchView = SearchView()
		
		// Create the window and set the content view.
		window = TypingWindow(
			contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
			styleMask: [.fullSizeContentView],
			backing: .buffered, defer: false)
		window.isReleasedWhenClosed = false
		window.center()
		window.backgroundColor = .clear
		window.hasShadow = false
		window.level = .floating
		window.contentView = NSHostingView(rootView: searchView)
		
		// Open the window and activate the application.
		activate()
	}
	
	func setupKeyboardShortcuts() {
		// Setup the shortcut for hiding and showing the search bar.
		KeyboardShortcutManager(keyboardShortcut: Configuration.decoded.activationKeyboardShortcut).startListeningForEvents { [self] _ in
			if window.isVisible {
				// Before closing the window, exit out of all running custom applications.
				NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
				
				// Close the window.
				window.close()
				
				// Hide the application so the application in the background activates automatically.
				NSApp.hide(nil)
			} else {
				// Activate the application and the search bar window.
				activate()
			}
		}
	}
	
	@objc func activate() {
		// Add the titled style mask, it will be removed later.
		window.styleMask.insert(.titled)
		
		// Make the application the main application.
		NSApp.activate(ignoringOtherApps: true)
		
		// Open the search bar window.
		window.makeKeyAndOrderFront(nil)
		
		// The titled style mask needs to be removed after the window ordered the front; Otherwise, it will stay in the background.
		window.styleMask.remove(.titled)
	}
	
	@objc func showSettingsWindow() {
		// Close the search bar.
		window.close()
		
		// Configure the settings window.
		settingsWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 320),
							  styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
							  backing: .buffered,
							  defer: false)
		settingsWindow.title = "Settings"
		settingsWindow.isReleasedWhenClosed = false
		settingsWindow.center()
		settingsWindow.contentView = NSHostingView(rootView: SettingsView())
		NSApp.activate(ignoringOtherApps: true)
		settingsWindow.makeKeyAndOrderFront(nil)
	}
}



// Snap.swift
//
// Created by TeChris on 20.03.21.

import Cocoa
import SwiftUI

class Snap {
	// The app delegate's snap instance.
	static let standard = (NSApp.delegate as! AppDelegate).snap
	
	// The menu bar status item.
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	// The menu of the status item.
	var menu: NSMenu!
	
	// The application's window.
	var window: NSWindow!
	
	// The settings window.
	var settingsWindow: NSWindow?
	
	func start() {
		// Request needed permissions
		Permissions.requestPermissions()
		
		// Setup the status item.
		setupStatusItem()
		
		// Open the search bar.
		openSearchWindow()
		
		// Setup the keyboard shortcuts.
		setupKeyboardShortcuts()
	}
	
	func deactivate() {
		// Deactivate the application.
		NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
		window.close()
	}

	private func setupStatusItem() {
		// If the status item doesn't have a button, then return.
		guard let button = statusItem.button else { return }
		
		// Set up the button.
		button.image = NSImage(systemSymbolName: "magnifyingglass", accessibilityDescription: nil)
		
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
					   action: #selector(quit),
					   keyEquivalent: "q")]
		
		for menuItem in menuItems {
			menuItem.target = self
			menu.addItem(menuItem)
		}
		
		statusItem.menu = menu
	}
	
	private func openSearchWindow() {
		// Create the SwiftUI view that provides the window contents.
		let searchView = SearchView()
		
		// Create the window and set the content view.
		window = NSWindow(
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
	
	private func setupKeyboardShortcuts() {
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
		
		// If the settings window is already on the screen, then return.
		if settingsWindow?.isVisible == true {
			return
		}
		
		// Configure the settings window.
		settingsWindow = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 520, height: 400),
								  styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
								  backing: .buffered,
								  defer: false)
		settingsWindow?.title = "Settings"
		settingsWindow?.isReleasedWhenClosed = false
		settingsWindow?.center()
		settingsWindow?.contentView = NSHostingView(rootView: SettingsView())
		NSApp.activate(ignoringOtherApps: true)
		settingsWindow?.makeKeyAndOrderFront(nil)
	}
	
	@objc func quit() {
		// Terminate the application.
		NSApp.terminate(nil)
	}
}

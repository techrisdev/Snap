// Snap.swift
//
// Created by TeChris on 20.03.21.

import Cocoa
import SwiftUI

class Snap {
	/// The app delegate's snap instance.
	static let standard = (NSApp.delegate as! AppDelegate).snap
	
	/// The menu bar status item.
	private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	/// The menu of the status item.
	private var menu: NSMenu!
	
	/// The application's search window.
	private var window: NSWindow!
	
	/// The app's settings window.
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
	
	let notificationCenter = NotificationCenter.default
	
	func deactivate() {
		// Deactivate the application.
		notificationCenter.post(name: .ApplicationShouldExit, object: nil)
		window.close()
		
		// Remove the listener for keyboard events.
		removeKeyboardMonitor()
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
		
		// Add all menu items to the menu.
		for menuItem in menuItems {
			// The target should be self, otherwise, actions won't be executed.
			menuItem.target = self
			
			menu.addItem(menuItem)
		}
		
		// Set the menu for the status item to the new menu.
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
				notificationCenter.post(name: .ApplicationShouldExit, object: nil)
				
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
		
		// Stop listening for events, they aren't relevant for the settings window.
		removeKeyboardMonitor()
	}
	
	@objc func quit() {
		// Terminate the application.
		NSApp.terminate(nil)
	}
	
	/// The currently listening keyboard monitor.
	private var monitor: Any?
	
	/// A monitor which recognizes specific key events and sends notifications.
	func addKeyboardMonitor() {
		monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [self] event in
			// The Up-Arrow key was pressed.
			if event.keyCode == 126 {
				// Post a notification.
				notificationCenter.post(name: .UpArrowKeyWasPressed, object: nil)
				
				// Return from the closure.
				return nil
			}
			
			// The Down-Arrow key was pressed.
			if event.keyCode == 125 {
				// Post a notification.
				notificationCenter.post(name: .DownArrowKeyWasPressed, object: nil)
				
				// Return from the closure.
				return nil
			}
			
			// The tab key was pressed.
			if event.keyCode == 48 {
				// Post a notification.
				notificationCenter.post(name: .TabKeyWasPressed, object: nil)
				
				// Return from the closure.
				return nil
			}
			
			// The key combination for quick look was pressed.
			// MARK: TODO: Make this combination configurable.
			// For now, the combination is always shift-q.
			let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
			if event.keyCode == 12 && modifierFlags == .shift {
				// Post a notification.
				notificationCenter.post(name: .ShouldPresentQuickLook, object: nil)
				
				// Return from the closure.
				return nil
			}
			
			// Get the event's characters.
			let characters = event.charactersIgnoringModifiers ?? ""
			
			// The return key was pressed.
			if characters == "\r" {
				// Post a notification.
				notificationCenter.post(name: .ReturnKeyWasPressed, object: nil)
				
				// Return from the closure.
				return nil
			}
			
			return event
		})
	}
	
	/// Stop listening for keyboard events.
	private func removeKeyboardMonitor() {
		// Unwrap the monitor. The monitor should never be nil because normally, the "addKeyboardMonitor" method is called before removing monitors. To avoid crashes because of mistakes, it's an optional anyway.
		guard let monitor = monitor else { return }
		
		// Remove the event monitor.
		NSEvent.removeMonitor(monitor)
	}
}

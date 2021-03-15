// AppDelegate.swift
//
// Created by TeChris on 08.03.21.

import Cocoa
import SwiftUI
import Carbon

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var window: TypingWindow!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		Permissions().requestPermissions { [self] in
			self.openSearchWindow()
			KeyboardShortcutManager(keyboardShortcut: KeyboardShortcut(keyCode: kVK_Space, modifierFlags: [.option], events: [.keyDown])).startListeningForEvents { _ in
				if NSApp.isHidden {
					NSApp.activate(ignoringOtherApps: true)
				} else {
					NSApp.hide(nil)
				}
			}
		}
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
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	func applicationDidResignActive(_ notification: Notification) {
		NSApp.hide(nil)
	}
}



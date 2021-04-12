// AppDelegate.swift
//
// Created by TeChris on 08.03.21.

import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	let snap = Snap()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Start the application.
		snap.start()
	}
	
	func applicationDidResignActive(_ notification: Notification) {
		// When the application loses focus, and the settings window isn't visible, then deactivate the application.
		if snap.settingsWindow == nil || !snap.settingsWindow!.isVisible {
			snap.deactivate()
		}
	}
}

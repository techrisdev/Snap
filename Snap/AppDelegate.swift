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
		// When the application loses focus, then deactivate the application.
		snap.deactivate()
	}
}

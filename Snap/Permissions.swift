// Permissions.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI
import EventKit
import Contacts

struct Permissions {
	
	static var isAccessibilityProcessTrusted = AXIsProcessTrusted()
	/// Request Permissions and set the Authorization Status in UserDefaults.
	func requestPermissions(action: @escaping () -> Void) {
		// Request access for Contacts.
		CNContactStore().requestAccess(for: .contacts, completionHandler: { result, _ in
			if !result {
				// MARK: TODO: Display a dialog.
				print("Access denied.")
			}
		})
		
		// Get the authorization status.
		let contactAuthorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
		
		// Set the value in UserDefaults so it can be used later.
		UserDefaults.standard.setValue(contactAuthorizationStatus.rawValue, forKey: "ContactAuthorizationStatus")
		
		// Request access for Calendar.
		EKEventStore().requestAccess(to: .event, completion: { result, _ in
			if !result {
				// MARK: TODO: Display a dialog.
				print("Access denied.")
			}
		})
		
		// Get the authorization status.
		let eventAuthorizationStatus = EKEventStore.authorizationStatus(for: .event)
		
		// Set the value in UserDefaults so it can be used later.
		UserDefaults.standard.setValue(eventAuthorizationStatus.rawValue, forKey: "EventAuthorizationStatus")
		
		// Request access for reminders.
		EKEventStore().requestAccess(to: .reminder, completion: { result, _ in
			if !result {
				// MARK: TODO: Display a dialog.
				print("Access denied.")
			}
		})
		
		// Get the authorization status.
		let remindersAuthorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
		
		// Set the value in UserDefaults so it can be used later.
		UserDefaults.standard.setValue(remindersAuthorizationStatus.rawValue, forKey: "RemindersAuthorizationStatus")
		
		if !Permissions.isAccessibilityProcessTrusted {
			let window = NSWindow(
				contentRect: NSRect(x: 0, y: 0, width: 400, height: 400),
				styleMask: [.titled, .fullSizeContentView],
				backing: .buffered,
				defer: false)
			window.isReleasedWhenClosed = false
			window.center()
			window.contentView = NSHostingView(rootView: AccessibilityPermissionView())
			window.makeKeyAndOrderFront(nil)
			NSApp.activate(ignoringOtherApps: true)
			window.styleMask.remove(.titled)
			
			waitUntilAccessibilityProcessIsTrusted {
				window.close()
				action()
			}
		} else {
			action()
		}
	}
	
	private func waitUntilAccessibilityProcessIsTrusted(action: @escaping () -> Void) {
		// After 0.35 seconds...
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.35, execute: {
			// Check if the process is trusted
			if AXIsProcessTrusted() {
				action()
			} else {
				// If not, then do the same thing again...
				waitUntilAccessibilityProcessIsTrusted(action: action)
			}
		})
	}
	
	struct AccessibilityPermissionView: View {
		@State private var accessibilityIcon = NSImage()
		var body: some View {
			VStack {
				Image(nsImage: accessibilityIcon)
				Text("Accessibility Permissions")
					.font(.title)
					.fontWeight(.bold)
				Spacer()
				Text("Snap needs Accessibility Permissions in order to activate through Keyboard Shortcuts or Hot Corners.")
				Spacer()
				VStack {
					Button(action: {
						// URL to the Accessibility Preferences
						if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
							// Open the URL
							NSWorkspace.shared.open(url)
						} else {
							print("The URL does not exist. This should never happen. :(")
						}
					}) {
						Text("Enable")
							.frame(width: 75)
					}
					.padding(5)
					
					Button(action: {
						// Quit the application.
						NSApp.terminate(nil)
					}) {
						Text("Quit")
							.frame(width: 75)
					}
				}
			}
			.padding()
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.onAppear(perform: {
				let accessibilityIcon = NSWorkspace.shared.icon(forFile: "/System/Library/PreferencePanes/UniversalAccessPref.prefPane")
				accessibilityIcon.size = NSSize(width: 200, height: 200)
				self.accessibilityIcon = accessibilityIcon
			})
		}
	}
}

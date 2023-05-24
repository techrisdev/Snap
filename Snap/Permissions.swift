// Permissions.swift
//
// Created by TeChris on 09.03.21.

import AppKit
import EventKit
import Contacts

class Permissions {
	/// Request Permissions and set the Authorization Status in UserDefaults.
	static func requestPermissions() {
		// Get the authorization status for contacts.
		let contactAuthorizationStatus = requestContactAccess()
		
		// Set the value in UserDefaults so it can be used later.
		UserDefaults.standard.setValue(contactAuthorizationStatus, forKey: "ContactAuthorizationStatus")
		
		// Get the authorization status for calendar events.
		let calendarAuthorizationStatus = requestCalendarAccess()
		
		// Set the value in UserDefaults so it can be used later.
		UserDefaults.standard.setValue(calendarAuthorizationStatus, forKey: "CalendarAuthorizationStatus")
		
		// Request Full Disk Access for accessing files in the user's home directory.
		requestFullDiskAccess()
		
		// Set the Full Disk Access status in UserDefaults so it can be used later.
		UserDefaults.standard.setValue(fullDiskAccess, forKey: "FullDiskAccess")
		
		// MARK: Searching for reminders doesn't work right now.
		// Request access for reminders.
//				EKEventStore().requestAccess(to: .reminder, completion: { result, _ in
//					if !result {
//						print("Access denied.")
//					}
//				})
//
//				// Get the authorization status.
//				let remindersAuthorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
//
//				// Set the value in UserDefaults so it can be used later.
//				UserDefaults.standard.setValue(remindersAuthorizationStatus.rawValue, forKey: "RemindersAuthorizationStatus")
	}
	
	/// Request access for Contacts.
	static private func requestContactAccess() -> Bool {
		var authorizationStatus = false
		CNContactStore().requestAccess(for: .contacts) { result, _ in
			authorizationStatus = result
		}
		
		// Return the authorization status for contacts.
		return authorizationStatus
	}
	
	/// Request access for Calendar events.
	static private func requestCalendarAccess() -> Bool {
		var authorizationStatus = false
		EKEventStore().requestAccess(to: .event) { result, _ in
			authorizationStatus = result
		}
		
		// Return the authorization status for calendar events.
		return authorizationStatus
	}
	
	/// The current authorization status for Full Disk Access.
	static private var fullDiskAccess: Bool {
		return FileManager.default.contents(atPath: "\(NSHomeDirectory())/Library/Safari/CloudTabs.db") != nil
	}
	
	/// Request access to folders like the users desktop folder.
	static private func requestFullDiskAccess() {
		// If there is Full Disk Access, return from the function.
		if fullDiskAccess {
			return
		}
		
		// Configure the alert.
		let alert = NSAlert()
		alert.messageText = "Snap would like to have Full Disk Access."
		alert.informativeText = "Full Disk Access is required for searching files all in your Home directory."
		alert.icon = NSWorkspace.shared.icon(forFile: "/System/Library/PreferencePanes/Security.prefPane")
		
		// Add the buttons.
		alert.addButton(withTitle: "OK")
		// TODO: FIX OK BUTTON (It doesn't close the alert)
		//let okButton = alert.addButton(withTitle: "OK")
//		okButton.target = self
//		okButton.action = #selector(showFullDiskAccessPreferences)
		
		alert.addButton(withTitle: "Don't Allow")
		
		// Present the alert.
		alert.runModal()
	}
	
	@objc static private func showFullDiskAccessPreferences(alert: NSAlert) {
		// Create a URL pointing to the Full Disk Access preferences.
		let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
		
		// Open the URL.
		NSWorkspace.shared.open(url)
	}
}

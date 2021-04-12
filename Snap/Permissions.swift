// Permissions.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI
import EventKit
import Contacts

struct Permissions {
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
		
		// MARK: Searching for reminders doesn't work right now.
		// Request access for reminders.
//		EKEventStore().requestAccess(to: .reminder, completion: { result, _ in
//			if !result {
//				print("Access denied.")
//			}
//		})
//
//		// Get the authorization status.
//		let remindersAuthorizationStatus = EKEventStore.authorizationStatus(for: .reminder)
//
//		// Set the value in UserDefaults so it can be used later.
//		UserDefaults.standard.setValue(remindersAuthorizationStatus.rawValue, forKey: "RemindersAuthorizationStatus")
	}
	
	static func requestContactAccess() -> Bool {
		// Request access for Contacts.
		var authorizationStatus = false
		CNContactStore().requestAccess(for: .contacts) { result, _ in
			authorizationStatus = result
		}
		
		// Return the authorization status for contacts.
		return authorizationStatus
	}
	
	static func requestCalendarAccess() -> Bool {
		// Request access for Calendar.
		var authorizationStatus = false
		EKEventStore().requestAccess(to: .event) { result, _ in
			authorizationStatus = result
		}
		
		// Return the authorization status for calendar events.
		return authorizationStatus
	}
}

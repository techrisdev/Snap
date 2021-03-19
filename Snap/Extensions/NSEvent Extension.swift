// NSEvent Extension.swift
//
// Created by TeChris on 19.03.21.

import Cocoa

extension NSEvent {
	/// A monitor which recognizes specific key events and sends notifications.
	static func addSnapKeyboardMonitor() {
		self.addLocalMonitorForEvents(matching: .keyDown, handler: { event in
			// The Up-Arrow key was pressed.
			if event.keyCode == 126 {
				// Post a notification.
				NotificationCenter.default.post(name: .UpArrowKeyWasPressed, object: nil)
				
				// Return from the function.
				return nil
			}
			
			// The Down-Arrow key was pressed.
			if event.keyCode == 125 {
				// Post a notification.
				NotificationCenter.default.post(name: .DownArrowKeyWasPressed, object: nil)
				
				// Return from the function.
				return nil
			}
			
			// The tab key was pressed.
			if event.keyCode == 48 {
				// Post a notification.
				NotificationCenter.default.post(name: .TabKeyWasPressed, object: nil)
				
				// Return from the function.
				return nil
			}
			
			// Get the event's characters.
			let characters = event.charactersIgnoringModifiers ?? ""
			
			// The return key was pressed.
			if characters == "\r" {
				// Post a notification.
				NotificationCenter.default.post(name: .ReturnKeyWasPressed, object: nil)
				
				// Return from the function.
				return nil
			}
			
			return event
		})
	}
}

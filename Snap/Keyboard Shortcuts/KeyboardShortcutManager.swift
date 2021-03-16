// KeyboardShortcutManager.swift
//
// Created by TeChris on 11.03.21.

import Carbon

class KeyboardShortcutManager {
	var keyboardShortcut: KeyboardShortcut
	
	init(keyboardShortcut: KeyboardShortcut) {
		self.keyboardShortcut = keyboardShortcut
	}

	private var currentEvent: KeyEvent = .keyUp
	
	func startListeningForEvents(actionOnEvent: @escaping (KeyEvent) -> Void) {
		// Create a HotKey ID.
		let eventHotKeyID = EventHotKeyID(signature: FourCharCode(1397966955), id: keyboardShortcut.id)
		
		// Register the shortcut.
		var eventHotKey: EventHotKeyRef?
		RegisterEventHotKey(keyboardShortcut.keyCode, keyboardShortcut.carbonModifiers, eventHotKeyID, GetEventDispatcherTarget(), 0, &eventHotKey)
		
		var eventHandler: EventHandlerRef?
		
		// The event specification for HotKey events.
		var eventSpecification = [EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed)),
								  EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyReleased))]

		// Install an event handler.
		InstallEventHandler(GetEventDispatcherTarget(), { (_, event, _) -> OSStatus in
			var hotKeyID = EventHotKeyID()
			
			// Get the EventHotKeyID from the event.
			GetEventParameter(event, UInt32(kEventParamDirectObject), UInt32(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hotKeyID)
			// Post a Notification with the ID.
			NotificationCenter.default.post(name: NSNotification.Name("HotKeyWithID\(hotKeyID.id)"), object: nil)
			return 0
		}, 2, &eventSpecification, nil, &eventHandler)
		
		// Do the given action when a notification with the ID comes in.
		NotificationCenter.default.addObserver(forName: Notification.Name("HotKeyWithID\(eventHotKeyID.id)"), object: nil, queue: nil, using: { [self] _ in
			// Set the current event.
			if currentEvent == .keyUp {
				currentEvent = .keyDown
			} else {
				currentEvent = .keyUp
			}
			
			// Check if the action should be executed by checking if the current event should be recognized.
			if keyboardShortcut.events.contains(currentEvent) {
				actionOnEvent(currentEvent)
			}
		})
	}
}

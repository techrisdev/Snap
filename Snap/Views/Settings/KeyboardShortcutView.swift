// KeyboardShortcutView.swift
//
// Created by TeChris on 18.03.21.

import SwiftUI

struct KeyboardShortcutView<Label> : View where Label : View {
	@Binding var keyboardShortcut: KeyboardShortcut
	var label: () -> Label
	
	init(keyboardShortcut: Binding<KeyboardShortcut>, @ViewBuilder label: @escaping () -> Label) {
		_keyboardShortcut = keyboardShortcut
		self.label = label
	}
	
	@State private var buttonText = ""
	@State private var monitor: Any!
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				label()
			}
			Button(action: {
				buttonText = ""
				
				monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [self] event in
					let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask).keyboardShortcutModifiers
					
					keyboardShortcut = KeyboardShortcut(key: Key(keyCode: UInt32(event.keyCode)), modifiers: modifiers, events: keyboardShortcut.events)
					
					buttonText.append(charactersForModifiers(modifiers) + " ")
					// The event's characters. They are uppercased for a better look.
					let characters = (event.charactersIgnoringModifiers ?? "").uppercased()
					if characters != "" {
						buttonText.append(characters.replacingOccurrences(of: " ", with: "Space "))
						removeEventMonitor()
					}
					
					return nil
				})
			}) {
				Text(buttonText)
			}
			.buttonStyle(BorderlessButtonStyle())
		}
		.onAppear {
			buttonText.append(charactersForModifiers(keyboardShortcut.modifiers) + " ")
			if keyboardShortcut.key.character == " " {
				// Replace the space character with a string.
				buttonText.append("Space")
			} else {
				buttonText.append(keyboardShortcut.key.character.uppercased())
			}
		}
	}
	
	private func charactersForModifiers(_ modifiers: [KeyboardShortcutModifier]) -> String {
		var result = ""
		
		if modifiers.contains(.command) {
			result.append("􀆔")
		}
		
		if modifiers.contains(.option) {
			result.append("􀆕")
		}
		
		if modifiers.contains(.control) {
			result.append("􀆍")
		}
		
		if modifiers.contains(.shift) {
			result.append("􀆝")
		}
		
		return result
	}
	
	private func removeEventMonitor() {
		// Remove the current monitor.
		NSEvent.removeMonitor(monitor!)
		monitor = nil
	}
}

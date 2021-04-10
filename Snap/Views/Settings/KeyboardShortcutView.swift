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
	
	@State private var buttonText = "Click to record"
	@State private var monitor: Any!
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				label()
			}
			Button(action: {
				buttonText = ""
				
				monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { [self] event in
					let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
					
					keyboardShortcut = KeyboardShortcut(keyCode: Int(event.keyCode), modifierFlags: modifierFlags, events: keyboardShortcut.events)
					
					buttonText.append(getCharactersForModifiers(modifierFlags) + " ")
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
			print(keyboardShortcut)
		}
	}
	
	private func getCharactersForModifiers(_ modifiers: NSEvent.ModifierFlags) -> String {
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

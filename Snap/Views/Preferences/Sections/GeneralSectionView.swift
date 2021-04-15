// GeneralSectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct GeneralSectionView: View {
	@Binding var backgroundColor: Color
	@Binding var textColor: Color
	@Binding var activationKeyboardShortcut: KeyboardShortcut
	@Binding var maximumWdith: CGFloat
	@Binding var maximumHeight: CGFloat
    var body: some View {
		PreferencesSection(text: "General") {
			ColorPicker("Background Color", selection: $backgroundColor)
			ColorPicker("Text Color", selection: $textColor)
			KeyboardShortcutView(keyboardShortcut: $activationKeyboardShortcut) {
				Text("Activation Shortcut:")
			}
			Slider(value: $maximumWdith, in: 20...1000) {
				Text("Maximum Window Height: \(maximumWdith, specifier: "%.0f")")
					.padding(.trailing, 7.5)
			}
			.padding(.trailing, 12.5)
			.frame(maxWidth: 435)
			Slider(value: $maximumHeight, in: 20...1000) {
				Text("Maximum Window Height: \(maximumHeight, specifier: "%.0f")")
					.padding(.trailing, 7.5)
			}
			.padding(.trailing, 12.5)
			.frame(maxWidth: 435)
		}
    }
}

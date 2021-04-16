// ClipboardHistorySectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct ClipboardHistorySectionView: View {
	@Binding var clipboardHistoryEnabled: Bool
	@Binding var mergeClipboardHistoryItemKeyboardShortcut: KeyboardShortcut
	@Binding var clipboardHistoryItemLimit: Int
    var body: some View {
		PreferencesSection(text: "Clipboard History") {
			Toggle("Enabled", isOn: $clipboardHistoryEnabled)
			KeyboardShortcutView(keyboardShortcut: $mergeClipboardHistoryItemKeyboardShortcut) {
				Text("Merge Last Item With New Copy Shortcut:")
			}
			Stepper("Item Limit: \(clipboardHistoryItemLimit)", value: $clipboardHistoryItemLimit)
		}
    }
}

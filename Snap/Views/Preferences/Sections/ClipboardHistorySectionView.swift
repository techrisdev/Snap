// ClipboardHistorySectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct ClipboardHistorySectionView: View {
	@Binding var clipboardHistoryEnabled: Bool
	@Binding var clipboardHistoryItemLimit: Int
	@Binding var mergeClipboardHistoryItemKeyboardShortcut: KeyboardShortcut
	@Binding var itemMergedSoundEnabled: Bool
    var body: some View {
		PreferencesSection(text: "Clipboard History") {
			Toggle("Enabled", isOn: $clipboardHistoryEnabled)
			Stepper("Item Limit: \(clipboardHistoryItemLimit)", value: $clipboardHistoryItemLimit)
			KeyboardShortcutView(keyboardShortcut: $mergeClipboardHistoryItemKeyboardShortcut) {
				Text("Merge Last Item With New Copy Shortcut:")
			}
			Toggle("Play sound on merge", isOn: $itemMergedSoundEnabled)
		}
    }
}

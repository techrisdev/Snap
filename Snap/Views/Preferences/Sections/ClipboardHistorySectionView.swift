// ClipboardHistorySectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct ClipboardHistorySectionView: View {
	@Binding var clipboardHistoryEnabled: Bool
	@Binding var historyItemLimit: Int
    var body: some View {
		PreferencesSection(text: "Clipboard History") {
			Toggle("Enabled", isOn: $clipboardHistoryEnabled)
			Stepper("Item Limit: \(historyItemLimit)", value: $historyItemLimit)
		}
    }
}

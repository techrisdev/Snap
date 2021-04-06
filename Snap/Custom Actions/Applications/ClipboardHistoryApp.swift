// ClipboardHistoryApp.swift
//
// Created by TeChris on 05.04.21.

import SwiftUI

struct ClipboardHistoryApp: ApplicationSearchItem {
	let id = UUID()
	
	var name = "Clipboard History"
	
	var acceptsArguments = false
	
	let view = ApplicationView(content: AnyView(ClipboardHistoryView()))
	
	struct ClipboardHistoryView: View {
		let items = ClipboardHistory.decoded.items
		let configuration = Configuration.decoded
		var body: some View {
			ClipboardHistoryListView(items: items)
		}
	}
}

// ClipboardHistoryApp.swift
//
// Created by TeChris on 05.04.21.

import SwiftUI

struct ClipboardHistoryApp: ApplicationSearchItem {
	let id = UUID()
	
	var name = "Clipboard History"
	
	var acceptsArguments = false
	
	let view = ApplicationView(content: AnyView(ClipboardHistoryView()), barView: AnyView(ClipboardHistoryBarView()))
}

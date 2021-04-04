// SettingsAction.swift
//
// Created by TeChris on 04.04.21.

import Foundation

struct SettingsAction: SearchItem {
	let id = UUID()
	
	var name = "Settings"
	
	var acceptsArguments = false
	
	var action: (String) -> Void = { _ in
		Snap.standard.showSettingsWindow()
	}
}

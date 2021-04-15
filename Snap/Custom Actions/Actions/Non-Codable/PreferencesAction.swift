// PreferencesAction.swift
//
// Created by TeChris on 04.04.21.

import Foundation

struct PreferencesAction: SearchItem {
	let id = UUID()
	
	var name = "Preferences"
	
	var acceptsArguments = false
	
	var action: (String) -> Void = { _ in
		Snap.default.showPreferencesWindow()
	}
}

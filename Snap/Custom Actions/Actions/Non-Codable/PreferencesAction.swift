// PreferencesAction.swift
//
// Created by TeChris on 04.04.21.

import Foundation

struct PreferencesAction: SearchItem {
	let id = UUID()
	
	let title = "Preferences"
	
	let acceptsArguments = false
	
	let action: (String) -> Void = { _ in
		Snap.default.showPreferencesWindow()
	}
}

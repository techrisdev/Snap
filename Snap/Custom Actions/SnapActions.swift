// SnapActions.swift
//
// Created by TeChris on 04.04.21.

import Foundation

/// Non-codable actions.
enum SnapAction: CaseIterable {
	case openPreferences
	
	/// All actions converted to search items.
	static var allItems: [SearchItem] = {
		var result = [SearchItem]()
		
		for action in SnapAction.allCases {
			switch action {
			case .openPreferences:
				result.append(PreferencesAction())
			}
		}
		
		return result
	}()
}

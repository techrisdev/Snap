// ActionSearch.swift
//
// Created by TeChris on 09.03.21.

import Foundation.NSPredicate

struct ActionSearch {
	private let actions = ActionDecoder.actions + SnapAction.allItems
	
	func searchForString(_ string: String) -> [SearchItem] {
		var result = [SearchItem]()
		
		for action in actions {
			var string = string

			// If the search contains arguments, then only check the string before the space.
			let stringSplitByWhitespaces = string.components(separatedBy: .whitespaces)
			if stringSplitByWhitespaces.indices.contains(1) {
				string = stringSplitByWhitespaces[0]
			}
		
			// Create a NSPredicate with the format.
			let predicate = NSPredicate(format: "'\(action.name)' like[cd] '\(string.replacingOccurrences(of: "'", with: "\\'"))\\*'")
			
			// Check if the predicate returned true.
			if predicate.evaluate(with: nil) {
				// Append the new item.
				result.append(action)
			}
		}
		
		return result
	}
}

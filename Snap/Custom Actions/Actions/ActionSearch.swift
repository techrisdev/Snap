// ActionSearch.swift
//
// Created by TeChris on 09.03.21.

import Cocoa

struct ActionSearch {
	private let actions = Action.allCases
	
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
			let predicate = NSPredicate(format: "'\(action.rawValue)' like[cd] '\(string)\\*'")
			
			// Check if the predicate returned true.
			if predicate.evaluate(with: nil) {
				let item = ActionSearchItem(action: Actions.getAction(for: action), name: action.rawValue.firstCharacterCapitalized())
				
				// Append the new item.
				result.append(item)
			}
		}
		
		return result
	}
}

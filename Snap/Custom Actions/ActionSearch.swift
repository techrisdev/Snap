// ActionSearch.swift
//
// Created by TeChris on 09.03.21.

import Foundation.NSPredicate
import Foundation

class ActionSearch {
	private var actions: [SearchItem]
	
	init() {
		self.actions = ActionDecoder.actions + SnapActions.allItems
		for action in actions {
			for blocked in Configuration.decoded.blockedActions {
				// Case insensitive
				var keywords = [String]()
				for keyword in action.keywords {
					keywords.append(keyword.lowercased())
				}
				if keywords.contains(blocked.lowercased()) {
					let index = actions.firstIndex { $0.keywords == action.keywords }
					actions.remove(at: index!)
				}
			}
		}
	}
	
	func searchForString(_ string: String) -> [SearchItem] {
		var result = [SearchItem]()
		
		for action in actions {
			var string = string

			// If the search contains arguments, then only check the string before the space.
			let stringSplitByWhitespaces = string.components(separatedBy: .whitespaces)
			if stringSplitByWhitespaces.indices.contains(1) {
				string = stringSplitByWhitespaces[0]
			}
			
			// Go through the keywords.
			for keyword in action.keywords {
				// Create a NSPredicate with the format.
				let predicate = NSPredicate(format: "'\(keyword)' like[cd] '\(string.replacingOccurrences(of: "'", with: "\\'"))\\*'")
				
				// Check if the predicate returned true.
				if predicate.evaluate(with: nil) {
					// Append the new item.
					result.append(action)
				}
			}
		}
		
		return result
	}
}

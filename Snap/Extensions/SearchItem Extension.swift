// SearchItem Extension.swift
//
// Created by TeChris on 19.03.21.

import Foundation

// Default Values for search items.
extension SearchItem {
	var icon: Icon {
		get {
			return Icon()
		}
	}
	
	var path: String {
		get {
			return ""
		}
	}
	
	func firstIndexInArray(_ array: [SearchItem]) -> Int? {
		// The index starts at -1 because the first index of an array is 0 and the number gets incremented at the start of the for loop (then, it's 0).
		var index = -1

		for element in array {
			index += 1
			if element.id == self.id {
				return index
			}
		}

		return nil
	}
}

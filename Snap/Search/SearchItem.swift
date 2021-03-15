// SearchItem.swift
//
// Created by TeChris on 08.03.21.

import Cocoa

/// A Search Item for Spotlight Searches.
class SearchItem: Identifiable, Equatable {
	static func == (lhs: SearchItem, rhs: SearchItem) -> Bool {
		if lhs.id == rhs.id {
			return true
		}
		
		return false
	}
	
	init(acceptsArguments: Bool) {
		self.acceptsArguments = acceptsArguments
	}

	/// The Item's UUID.
	let id = UUID()
	
	/// The Item's name.
	var name: String {
		return "Generic SearchItem"
	}
	
	/// The Item's kind.
	var kind: String? {
		return "SearchItem"
	}
	
	/// The icon as an NSImage.
	var icon: NSImage {
		return NSImage()
	}
	
	/// The path to the item.
	var path: String {
		return ""
	}
	
	/// Indicates if the item accepts arguments.
	var acceptsArguments: Bool
	
	var action: (String) -> Void {
		fatalError("Action on a generic item.")
	}
}

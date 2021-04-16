// SearchItem.swift
//
// Created by TeChris on 08.03.21.

import Foundation

/// A Search Item for Spotlight Searches.
protocol SearchItem {
	/// The item's UUID.
	var id: UUID { get }
	
	/// The item's title.
	var title: String { get }
	
	/// The item's keywords.
	var keywords: [String] { get }
	
	/// The item's icon.
	var icon: Icon { get }
	
	/// The path to the item.
	var path: String { get }

	/// Indicates if the item accepts arguments.
	var acceptsArguments: Bool { get }
	
	/// The item's action.
	var action: (String) -> Void { get }
}

extension SearchItem {
	var keywords: [String] {
		get {
			return [title]
		}
	}
}

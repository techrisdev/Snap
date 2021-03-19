// SearchItem.swift
//
// Created by TeChris on 08.03.21.

import Cocoa

/// A Search Item for Spotlight Searches.
protocol SearchItem {
	/// The item's UUID.
	var id: UUID { get }
	
	/// The item's name.
	var name: String { get }
	
	/// The item's icon.
	var icon: Icon { get }
	
	/// The path to the item.
	var path: String { get }

	/// Indicates if the item accepts arguments.
	var acceptsArguments: Bool { get }
	
	/// The item's action.
	var action: (String) -> Void { get }
}

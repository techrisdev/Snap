// ApplicationSearch.swift
//
// Created by TeChris on 14.03.21.

import Foundation

struct ApplicationSearch {
	private let applications = Application.allCases
	
	func searchForString(_ string: String) -> [SearchItem] {
		var result = [SearchItem]()
		
		// Replace the "'" character, so the predicate doesn't crash.
		let string = string.replacingOccurrences(of: "'", with: "\\'")
		
		for application in applications {
			// Create a NSPredicate with the format.
			let predicate = NSPredicate(format: "'\(application.rawValue)' like[cd] '\(string))\\*'")
			
			// If the predicate returned true, then append the new item.
			if predicate.evaluate(with: nil) {
				let item = getApplicationSearchItem(for: application)
				
				// Append the new item.
				result.append(item)
			}
		}
		
		return result
		
	}
	
	private func getApplicationSearchItem(for application: Application) -> SearchItem {
		switch application {
		case .music:
			return MusicControllerApp()
		}
	}
}

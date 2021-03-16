// Bookmark.swift
//
// Created by TeChris on 13.03.21.

import Foundation

struct Bookmark: Decodable {
	static var decodedBookmarks = Bookmark.decode()
	
	var Title: String?
	var Children: [Bookmark]?
	var URLString: String?
	
	// MARK: The bookmark search isn't working properly.
	func searchForBookmarks(_ searchString: String) -> [Bookmark] {
		var result = [Bookmark]()
		
		// If there is a URL string, then...
		if let urlString = URLString {
			
			// Create a NSPredicate.
			let predicate = NSPredicate(format: "'\(urlString)' like[cd] '\\*\(searchString)\\*'")
			
			// If the predicate returns true, then return the bookmark.
			if predicate.evaluate(with: nil) {
				result.append(self)
			}
		}
		
		// Go through all the children and search for the string.
		guard let children = Children else { return result }
		for child in children {
			let searchResult = child.searchForBookmarks(searchString)
			
			if !searchResult.isEmpty {
				result += searchResult
			}
		}
		print(result.count)
		return result
	}
	
	private static func decode() -> Bookmark {
		let fileURL = URL(fileURLWithPath: "\(NSHomeDirectory())/Library/Safari/Bookmarks.plist")
		guard let data = try? Data(contentsOf: fileURL) else { fatalError("Failed to get data from URL '\(fileURL)'.") }
		
		// Decode the Safari bookmarks.
		let decoder = PropertyListDecoder()
		guard let result = try? decoder.decode(Bookmark.self, from: data) else { fatalError("Failed to decode the Bookmarks.plist file.") }
		
		return result
	}
}

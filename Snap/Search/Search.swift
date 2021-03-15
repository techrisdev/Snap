// Search.swift
//
// Created by TeChris on 08.03.21.

import SwiftUI

/// Search for Spotlight Metadata.
class Search: NSObject, ObservableObject {
	/// The search results.
	@Published var results = [SearchItem]()
	
	/// The metadata query instance.
	private var metadataQuery = NSMetadataQuery()
	
	/// Search for a string in the Spotlight Database.
	func startSearchForString(_ string: String) {
		// Register notification for updates.
		// You recieve this notification if the metadata query finished gathering results.
		NotificationCenter.default.addObserver(forName: .NSMetadataQueryDidFinishGathering, object: nil, queue: nil, using: { [self] _ in
			// Reset the results.
			results = [SearchItem]()
			
			// If an Action for the string exists, then append the action to the search results.
			let actionSearch = ActionSearch()
			results += actionSearch.searchForString(string)
			
			// If an Action for the string exists, then append the action to the search results.
			let applicationSearch = ApplicationSearch()
			let searchResults = applicationSearch.searchForString(string)
			results += searchResults
			
			// If there are results, then go through the search results.
			let metadataQueryResults = metadataQuery.results as! [NSMetadataItem]

			if !metadataQueryResults.isEmpty {
				for result in metadataQueryResults {
					// Limit the result to 30 elements.
					if results.count > Configuration.decoded.itemLimit {
						break
					}

					// Create a new SearchItem.
					let searchItem = SpotlightSearchItem(item: result)

					// Check if the item's path is blocked.
					var shouldAppendItem = true
					for path in Configuration.decoded.blockedPaths {
						// Create a predicate.
						let predicate = NSPredicate(format: "'\(searchItem.path)' like '\(path)\\*'")
						
						// If the path of the item is blocked, then don't append the item.
						if predicate.evaluate(with: nil) {
							shouldAppendItem = false
							break
						}
					}
					
					// If the item's path isn't blocked, and the item should be appended, then append the new SearchItem to the Search results.
					if shouldAppendItem {
						results.append(searchItem)
					}
				}
			}

			// Append the web search items.
			for type in WebSearchType.allCases {
				results.append(WebSearchItem(searchString: string, searchType: type))
			}
			
			// MARK: The bookmark search isn't working properly right now.
//			let bookmarks = Bookmark.decodedBookmarks.searchForBookmarks(string)
//			for bookmark in bookmarks {
//				results.append(WebSearchItem(searchString: bookmark.URLString ?? "", searchType: .url, name: bookmark.URLString ?? "", takesNameAsArgument: true))
//			}
		})
		
		// Configure the search predicate to find all Items that begin with the given string.
		metadataQuery.predicate = NSPredicate(fromMetadataQueryString: "kMDItemDisplayName = \"\(string)*\"wcd")
		
		// Set the search scope to the whole Computer.
		metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
		
		// Sort by the item's relevance.
		metadataQuery.sortDescriptors = [NSSortDescriptor(key: kMDQueryResultContentRelevance as String, ascending: false)]
		
		// Start the metadata query.
		metadataQuery.start()
	}
	
	/// Stop the current query.
	func stopSearch() {
		metadataQuery.stop()
	}
}

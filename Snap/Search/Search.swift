// Search.swift
//
// Created by TeChris on 08.03.21.

import SwiftUI

/// Search for Spotlight Metadata.
class Search: ObservableObject {
	/// The search results.
	@Published var results = [SearchItem]()
	
	/// The metadata query instance.
	private var metadataQuery = NSMetadataQuery()
	
	private var currentString = ""
	
	init() {
		// Set up the search.
		setUp()
	}
	
	/// Search for a string in the Spotlight Database.
	func searchForString(_ string: String) {
		// Update the current string.
		currentString = string
		
		// Stop the query in case it is already running.
		stopSearch()
		
		// Configure the search predicate to find all Items that begin with the given string.
		metadataQuery.predicate = NSPredicate(fromMetadataQueryString: "kMDItemDisplayName = \"\(string)*\"wcd")
		
		// Start the metadata query.
		metadataQuery.start()
	}
	
	/// Stop the current query.
	func stopSearch() {
		metadataQuery.stop()
	}
	
	let actionSearch = ActionSearch()
	let applicationSearch = ApplicationSearch()
	
	@objc private func metadataQueryDidFinishGathering() {
		// Execute code on the main queue.
		DispatchQueue.main.async { [self] in
			// Reset the results.
			results = [SearchItem]()
			
			// If an Action for the string exists, then append the action to the search results.
			results += actionSearch.searchForString(currentString)
			
			// If an Action for the string exists, then append the action to the search results.
			let searchResults = applicationSearch.searchForString(currentString)
			results += searchResults
			
			// If there are results, then go through the search results.
			let metadataQueryResults = metadataQuery.results as! [NSMetadataItem]
			if !metadataQueryResults.isEmpty {
				for result in metadataQueryResults {
					// Limit the result to 30 elements.
					if results.count > Configuration.decoded.resultItemLimit {
						break
					}
					
					// Create a new SearchItem.
					let searchItem = SpotlightSearchItem(result)
					
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
			results += WebSearch.searchItemsFromString(currentString)
			
			// Check if the text has a first character.
			if let firstCharacter = currentString.first {
				// If the first character is a number, a minus or plus sign or a bracket, insert the calculator into the results.
				if firstCharacter.isNumber || firstCharacter == "-" || firstCharacter == "+" || firstCharacter == "(" {
					results.insert(CalculatorSearchItem(calculation: currentString), at: 0)
				}
			}
			// MARK: TODO - The bookmark search isn't working properly right now.
			//			let bookmarks = Bookmark.decodedBookmarks.searchForBookmarks(string)
			//			for bookmark in bookmarks {
			//				results.append(WebSearchItem(searchString: bookmark.URLString ?? "", searchType: .url, name: bookmark.URLString ?? "", takesNameAsArgument: true))
			//			}
		}
	}
	
	/// Set up the NSMetadataQuery and notifications.
	private func setUp() {
		// Configure the metadata query.
		// Set the search scope to the whole Computer.
		metadataQuery.searchScopes = [NSMetadataQueryLocalComputerScope]
		
		// Sort by the item's relevance.
		metadataQuery.sortDescriptors = [NSSortDescriptor(key: kMDQueryResultContentRelevance as String, ascending: false)]
		
		// Configure an operation queue to improve performance.
		let operationQueue = OperationQueue()
		operationQueue.qualityOfService = .userInteractive
		
		// Set the metadata query's operation queue to the new operation queue.
		metadataQuery.operationQueue = operationQueue
		
		// Register a notification for updates on the NSMetadataQuery gathering process.
		NotificationCenter.default.addObserver(self, selector: #selector(metadataQueryDidFinishGathering), name: .NSMetadataQueryDidFinishGathering, object: nil)
	}
}

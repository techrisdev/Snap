// WebSearchItem.swift
//
// Created by TeChris on 10.03.21.

import AppKit

struct WebSearchItem: SearchItem {
	init(searchType: WebSearchType, name: String? = nil, acceptsArguments: Bool = false, takesNameAsArgument: Bool = false) {
		self.searchType = searchType
		self.takesNameAsArgument = takesNameAsArgument
		self.acceptsArguments = acceptsArguments
		var name = "Web Search"

		if searchType != .url {
			self.title = name
			// Set the action to nothing so it can be used.
			action = { _ in }
			
			action = search
		} else {
			name = "URL"
			self.title = name
			action = openURL
		}
	}
	
	let id = UUID()
	
	var title: String
	
	var acceptsArguments: Bool
	
	var action: (String) -> Void
	
	var takesNameAsArgument: Bool
	
	private var searchType: WebSearchType
	
	private var search: (String) -> Void {
		return { search in
			let search = search.replacingOccurrences(of: " ", with: "+").replacingOccurrences(of: "\\", with: "%5C")
			var url: URL?
			switch searchType {
			case .google:
				url = URL(string: "https://google.com/search?q=\(search)")
			case .duckduckgo:
				url = URL(string: "https://duckduckgo.com/?q=\(search)")
			case .bing:
				url = URL(string: "https://www.bing.com/search?q=\(search)")
			case .yahoo:
				url = URL(string: "https://www.yahoo.com/search?q=\(search)")
			case .ecosia:
				url = URL(string: "https://www.ecosia.org/search?q=\(search)")
			default:
				fatalError("The search type is \(searchType). This should never happen.")
			}
			
			// Check if the URL isn't nil.
			if url != nil {
				NSWorkspace.shared.open(url!)
			}
		}
	}
 
//	private var googleSearch: (String) -> Void = { search in
//		if let url = URL(string: "https://google.com/search?q=\(search.replacingOccurrences(of: " ", with: "+"))") {
//
//		}
//	}
//
//	private var duckDuckGoSearch: (String) -> Void = { search in
//		if let url = URL(string: "https://duckduckgo.com/?q=\(search.replacingOccurrences(of: " ", with: "+"))") {
//			NSWorkspace.shared.open(url)
//		}
//	}
	
	/// Open an URL safely by appending "https://" if necessary.
	private let openURL: (String) -> Void = { string in
		var urlString = string
		if !string.contains("https://") {
			if !string.contains("http://") {
				urlString = "https://" + string
			}
		}

		if let url = URL(string: urlString) {
			NSWorkspace.shared.open(url)
		} else {
			let alert = NSAlert()
			alert.informativeText = "URL Error"
			alert.messageText = "\(urlString) is not a valid URL."
		}
	}
}

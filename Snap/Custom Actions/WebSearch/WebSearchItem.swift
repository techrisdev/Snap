// WebSearchItem.swift
//
// Created by TeChris on 10.03.21.

import Cocoa

struct WebSearchItem: SearchItem {
	init(searchString: String, searchType: WebSearchType, name: String? = nil, acceptsArguments: Bool = false, takesNameAsArgument: Bool = false) {
		self.searchString = searchString
		self.searchType = searchType
		self.takesNameAsArgument = takesNameAsArgument
		
		let name = name ?? searchType.rawValue

		switch searchType {
		case .google:
			self.action = googleSearch
			self.name = name
			self.acceptsArguments = acceptsArguments
		case .duckduckgo:
			self.action = duckDuckGoSearch
			self.name = name
			self.acceptsArguments = acceptsArguments
		case .url:
			self.action = openURL
			self.name = name
			self.acceptsArguments = acceptsArguments
		}
	}
	
	var id = UUID()
	
	var name: String
	
	var acceptsArguments: Bool
	
	var action: (String) -> Void
	
	var icon: Icon {
		return Icon(path: "")
	}
	
	var takesNameAsArgument: Bool
	
	private var searchType: WebSearchType
	
	private var searchString: String
	
	private var googleSearch: (String) -> Void = { search in
		if let url = URL(string: "https://google.com/search?q=\(search.replacingOccurrences(of: " ", with: "+"))") {
			NSWorkspace.shared.open(url)
		}
	}
	
	private var duckDuckGoSearch: (String) -> Void = { search in
		if let url = URL(string: "https://duckduckgo.com/?q=\(search.replacingOccurrences(of: " ", with: "+"))") {
			NSWorkspace.shared.open(url)
		}
	}
	
	/// Open an URL safely by appending "https://" if necessary.
	private var openURL: (String) -> Void = { string in
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

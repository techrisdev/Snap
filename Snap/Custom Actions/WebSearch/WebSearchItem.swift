// WebSearchItem.swift
//
// Created by TeChris on 10.03.21.

import Cocoa

class WebSearchItem: ActionSearchItem {
	init(searchString: String, searchType: WebSearchType, name: String? = nil, acceptsArguments: Bool = false, takesNameAsArgument: Bool = false) {
		self.searchString = searchString
		self.searchType = searchType
		self.takesNameAsArgument = takesNameAsArgument
		
		let name = name ?? searchType.rawValue

		switch searchType {
		case .google:
			super.init(action: googleSearch, name: name, acceptsArguments: acceptsArguments)
		case .duckduckgo:
			super.init(action: duckDuckGoSearch, name: name, acceptsArguments: acceptsArguments)
		case .url:
			super.init(action: openURL, name: name, acceptsArguments: acceptsArguments)
		}
	}
	
	override var icon: NSImage {
		let image = NSImage(named: searchType.rawValue + "Icon")!
		image.size = Configuration.decoded.iconSize
		return image
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

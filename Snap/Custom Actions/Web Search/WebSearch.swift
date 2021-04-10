// WebSearch.swift
//
// Created by TeChris on 10.04.21.

import Foundation

struct WebSearch {
	static func searchItemsFromString(_ string: String) -> [WebSearchItem] {
		var result = [WebSearchItem]()
		
		let predicate = NSPredicate(format: "SELF like '\\*.\\*'")
		if predicate.evaluate(with: string) {
			// URL search should work.
			result.append(WebSearchItem(searchType: .url))
		}
		
		result.append(WebSearchItem(searchType: defaultSearchType))
		
		return result
	}
	
	/// Get the default system search engine from Safari.
	static private var defaultSearchType: WebSearchType = {
		// Get the default search engine.
		let process = Process()
		let pipe = Pipe()
		process.launchPath = "/bin/zsh"
		process.arguments = ["-c", "defaults read -g NSPreferredWebServices | grep 'NSDefaultDisplayName'"]
		process.standardOutput = pipe
		process.launch()
		
		let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
		guard let outputString = String(data: outputData, encoding: .utf8) else { fatalError("Failed to get output from process.") }
		// Remove unnecessary characters.
		var searchEngine = outputString
		searchEngine = searchEngine.replacingOccurrences(of: ";", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: "")
		for character in searchEngine {
			if character != "=", let index = searchEngine.firstIndex(of: character) {
				searchEngine.remove(at: index)
			} else {
				// Remove the equal sign.
				searchEngine.removeFirst()
				
				// Break the loop; The string should now be the search engine.
				break
			}
		}
		
		switch searchEngine {
		case "Google":
			return .google
		case "DuckDuckGo":
			return .duckduckgo
		case "Yahoo":
			return .yahoo
		case "Bing":
			return .bing
		case "Ecosia":
			return .ecosia
		default:
			fatalError("Unknown Search Engine.")
		}
	}()
}

// ActionDecoder.swift
//
// Created by TeChris on 10.03.21.

import AppKit

struct ActionDecoder {
	/// The decoded actions.
	static let actions = decode()
	
	static private func decode() -> [ActionSearchItem] {
		let decoder = JSONDecoder()
		
		// The urls where actions are stored.
		let defaultActionsURL = Bundle.main.url(forResource: "Actions", withExtension: "json")!
		let userDefinedActionsURL = URL(fileURLWithPath: Configuration.applicationSupportURL.path + "Actions.json")
		
		var result = [ActionSearchItem]()
		
		let urls = [defaultActionsURL, userDefinedActionsURL]
		for url in urls {
			// Get the data from the url.
			guard let data = try? Data(contentsOf: url) else { continue }
			
			// Decode the file.
			do {
				result += try decoder.decode([ActionSearchItem].self, from: data)
			} catch {
				// Present an alert with the error that occured.
				let alert = NSAlert()
				alert.messageText = "Action Error"
				alert.informativeText = "Something is wrong with your Actions.json file.\n\n Error: \(error)"
				alert.runModal()
			}
		}
		
		return result
	}
}

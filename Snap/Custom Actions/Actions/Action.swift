// Action.swift
//
// Created by TeChris on 10.03.21.

import Cocoa

struct Action: Codable {
	static let decodedActions = decode()
	
	var name: String
	
	var appleScript: String
	
	var action: (String) -> Void {
		return { arguments in
			let appleScriptWithArguments = appleScript.replacingOccurrences(of: "\\arguments\\", with: "\(arguments)")
			print(appleScript)
			print(appleScriptWithArguments)
			AppleScript.executeByTellingSystemEvents(string: appleScriptWithArguments)
		}
	}
	
	static private func decode() -> [Action] {
		let decoder = JSONDecoder()
		
		// The urls where actions are stored.
		let defaultActionsURL = Bundle.main.url(forResource: "Actions", withExtension: "json")!
		let userDefinedActionsURL = URL(fileURLWithPath: Configuration.applicationSupportURL.path + "Actions.json")
		
		var result = [Action]()
		
		let urls = [defaultActionsURL, userDefinedActionsURL]
		for url in urls {
			// Get the data from the url.
			guard let data = try? Data(contentsOf: url) else { continue }
			
			// Decode the file.
			do {
				result += try decoder.decode([Action].self, from: data)
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

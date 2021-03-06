// Configuration.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct Configuration: Codable {
	static let decoded = decodeConfigurationFile()
	
	// General preferences
	var backgroundColor: String
	var textColor: String
	var activationKeyboardShortcut: KeyboardShortcut
	var maximumWidth: CGFloat
	var maximumHeight: CGFloat
	
	// Search bar preferences
	var searchBarFont: Font
	var searchBarHeight: CGFloat
	var insertionPointColor: String
	
	// Result preferences
	var showingIcons: Bool
	var blockedPaths: [String]
	var iconSizeWidth: Int
	var iconSizeHeight: Int
	var resultItemFont: Font
	var resultItemHeight: CGFloat
	var resultItemLimit: Int
	var shouldAnimateNavigation: Bool
	var selectedItemBackgroundColor: String
	var showPathKeyboardShortcut: KeyboardShortcut
	var quickLookKeyboardShortcut: KeyboardShortcut
	
	// Clipboard History
	var clipboardHistoryEnabled: Bool
	var clipboardHistoryItemLimit: Int
	var copyLastItemToClipboardKeyboardShortcut: KeyboardShortcut
	var mergeClipboardHistoryItemKeyboardShortcut: KeyboardShortcut
	var itemMergedSoundEnabled: Bool
	
	// Snippet Expansion
	var snippetExpansionEnabled: Bool
	var snippets: [Snippet]

	static private func decodeConfigurationFile() -> Configuration {
		let decoder = JSONDecoder()
		let defaultConfigurationURL = Bundle.main.url(forResource: "DefaultConfiguration", withExtension: "json")!
		
		let applicationSupportURL = Snap.applicationSupportURL
		do {
			let fileManager = FileManager.default

			// Check if the Application Support directory for Snap exists; If it doesn't, then create it.
			if !fileManager.fileExists(atPath: applicationSupportURL.path) {
				try? fileManager.createDirectory(at: applicationSupportURL, withIntermediateDirectories: false, attributes: nil)
			}
			
			let pathToConfiguration = applicationSupportURL.path + "/Configuration.json"
			
			// Check if the configuration file exists; If it doesn't, then copy the default configuration to the path.
			if !fileManager.fileExists(atPath: pathToConfiguration) {
				let path = defaultConfigurationURL.path
				do {
					try fileManager.copyItem(atPath: path, toPath: pathToConfiguration)
				} catch {
					// This should never happen, but if something goes wrong, then present an alert.
					NSAlert(error: error).runModal()
				}
			}
			
			let url = URL(fileURLWithPath: pathToConfiguration)
			let data = try Data(contentsOf: url)
			return try decoder.decode(Configuration.self, from: data)
		} catch {
			// Present an alert with the error that occured.
			let alert = NSAlert()
			alert.messageText = "Configuration Error"
			alert.informativeText = "Something is wrong with your configuration file.\n\n Error: \(error)"
			alert.runModal()
		}
		
		// If the decoding process failed, return the decoded default configuration.
		// The default configuration must contain data, that's why it is force unwrapped. If the file doesn't contain any data, then something is really wrong!
		let data = try! Data(contentsOf: defaultConfigurationURL)
		guard let defaultConfiguration = try? decoder.decode(Configuration.self, from: data) else { fatalError("Failed to decode the default configuration.") }
		
		// Return the default configuration.
		return defaultConfiguration
	}
	
	/// Write a configuration file to the default path.
	func write() {
		let encoder = JSONEncoder()
		do {
			// Encode the configuration.
			let jsonData = try encoder.encode(self)
			
			// Write the data.
			try jsonData.write(to: Snap.applicationSupportURL.appendingPathComponent("/Configuration.json"))
		} catch {
			fatalError("Failed to write the configuration. Error: \n\(error)")
		}
	}
}

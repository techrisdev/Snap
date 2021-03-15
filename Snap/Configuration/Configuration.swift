// Configuration.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct Configuration: Decodable {
	static let decoded = decodeConfigurationFile()
	
	var backgroundColor = "#111111"
	var textColor = "#FFFFFF"
	var showingIcons = true
	var iconSizeWidth = 35
	var iconSizeHeight = 50
	var blockedPaths = ["/Users/christopherkleiner/Library/Containers/", "/System/Library/Frameworks/", "/System/Library/PrivateFrameworks/", "/usr/"]
	var resultHeight = CGFloat(70)
	var itemLimit = 25
	var searchBarFontSize = CGFloat(24)
	var searchBarHeight = CGFloat(50)
	var maxHeight = CGFloat(450)
	var shouldAnimateText = false
	var shouldAnimateNavigation = true
	var selectedItemBackgroundColor = "#0000FF"
	
	static private func decodeConfigurationFile() -> Configuration {
		let decoder = JSONDecoder()
		let defaultConfigurationURL = Bundle.main.url(forResource: "DefaultConfiguration", withExtension: "json")!
		
		do {
			let fileManager = FileManager.default
			
			let applicationSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Snap/")
			
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
		guard let defaultConfiguration = try? decoder.decode(Configuration.self, from: data) else { fatalError("Failed to decode default configuration!") }
		
		// Return the default configuration.
		return defaultConfiguration
	}
}

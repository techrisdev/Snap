// Configuration.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct Configuration: Decodable {
	static let decoded = decodeConfigurationFile()
	
	var background = AnyView(Color.black)
	var textColor = Color.white
	var showingIcons = true
	var iconSize = NSSize(width: 35, height: 50)
	var blockedPaths = ["/Users/christopherkleiner/Library/Containers/", "/System/Library/Framxeworks/", "/System/Library/PrivateFrameworks/", "/usr/"]
	var resultHeight = CGFloat(70)
	var itemLimit = 25
	var searchBarFontSize = CGFloat(24)
	var searchBarHeight = CGFloat(50)
	var maxHeight = CGFloat(450)
	var shouldAnimateText = false
	var shouldAnimateNavigation = true
	var selectedItemBackground = AnyView(Color.blue)
	
	enum CodingKeys: String, CodingKey {
		case background
		case textColor
		case maxHeight
		case shouldAnimateText
		case shouldAnimateNavigation
		case searchBarHeight
		case searchBarFontSize
		case resultHeight
		case showingIcons
		case iconSize
		case selectedItemBackground
	}
	
	static private func decodeConfigurationFile() -> Configuration {
		do {
			let applicationSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("Snap/")
			if !FileManager.default.fileExists(atPath: applicationSupportURL.path, isDirectory: nil) {
				try? FileManager.default.createDirectory(at: applicationSupportURL, withIntermediateDirectories: false, attributes: nil)
			}
			
			let pathToConfiguration = applicationSupportURL.path + "/" + "Configuration.json"
			
			FileManager.default.createFile(atPath: pathToConfiguration, contents: "{\"background\": \"blue\"}".data(using: .utf8), attributes: nil)
			let url = URL(fileURLWithPath: pathToConfiguration)
			let data = try Data(contentsOf: url)
			let decoder = JSONDecoder()
			return try decoder.decode(Configuration.self, from: data)
		} catch {
			fatalError("\(error)")
		}
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		background = AnyView(Color(try container.decode(String.self, forKey: .background)))
		//	let values = try decoder.container(keyedBy: CodingKeys.self)
			//result.background = AnyView(Color("blue"))
			
//		} catch {
//			// Show an alert containing the error.
//			let alert = NSAlert()
//			alert.informativeText = "Configuration Error"
//			alert.messageText = "Something is wrong with your configuration. Error: \(error)"
//		}
	}
	
//	static private func decode(from decoder: Decoder) -> Configuration {
//		var result = Configuration()
//
//		do {
//			let values = try decoder.container(keyedBy: CodingKeys.self)
//			result.background = AnyView(Color("blue"))
//
//		} catch {
//			// Show an alert containing the error.
//			let alert = NSAlert()
//			alert.informativeText = "Configuration Error"
//			alert.messageText = "Something is wrong with your configuration. Error: \(error)"
//		}
//
//		return result
//	}
}

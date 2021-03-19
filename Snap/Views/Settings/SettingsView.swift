// SettingsView.swift
//
// Created by TeChris on 17.03.21.

import SwiftUI

struct SettingsView: View {
	static private var configuration = Configuration.decoded
	
	@State private var showingBlockedPaths = false
	
	// General Settings
	@State private var backgroundColor = Color.fromHexString(configuration.backgroundColor)
	@State private var textColor = Color.fromHexString(configuration.textColor)
	@State private var activationKeyboardShortcut = configuration.activationKeyboardShortcut
	@State private var maximumHeight = configuration.maxHeight
	
	// Search bar settings
	@State private var searchBarFontSize = configuration.searchBarFontSize
	@State private var searchBarHeight = configuration.searchBarHeight
	@State private var insertionPointColor = Color.fromHexString(configuration.insertionPointColor)
	@State private var shouldAnimateText = configuration.shouldAnimateText
	
	// Result settings
	@State private var showingIcons = configuration.showingIcons
	@State private var blockedPaths = configuration.blockedPaths
	@State private var iconWidth = configuration.iconSizeWidth
	@State private var iconHeight = configuration.iconSizeHeight
	@State private var resultItemHeight = configuration.resultItemHeight
	@State private var resultItemLimit = configuration.itemLimit
	@State private var shouldAnimateNavigation = configuration.shouldAnimateNavigation
	@State private var selectedItemBackgroundColor = Color.fromHexString(configuration.selectedItemBackgroundColor)
	
	var body: some View {
		VStack {
			Text("Settings")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.top)
			
			ScrollView {
				SettingsSection(text: "General") {
					VStack(alignment: .leading) {
						ColorPicker("Background Color", selection: $backgroundColor)
						ColorPicker("Text Color", selection: $textColor)
						KeyboardShortcutView(keyboardShortcut: $activationKeyboardShortcut) {
							Text("Activation Shortcut:")
						}

						Slider(value: $maximumHeight, in: 20...1000) {
							Text("Maximum Window Height: \(maximumHeight, specifier: "%.0f")")
								.padding(.trailing, 7.5)
						}
						.padding(.trailing, 12.5)
						.frame(maxWidth: 435)
					}
				}
				
				SettingsSection(text: "Search Bar") {
					VStack(alignment: .leading) {
						Stepper("Font Size: \(searchBarFontSize, specifier: "%g")", value: $searchBarFontSize)
						Stepper("Height: \(searchBarHeight, specifier: "%g")", value: $searchBarHeight)
						ColorPicker("Insertion Point Color", selection: $insertionPointColor)
						Toggle("Animated Text", isOn: $shouldAnimateText)
					}
				}
				
				SettingsSection(text: "Results") {
					VStack(alignment: .leading) {
						Toggle("Showing Icons", isOn: $showingIcons)
						Button(action: {
							showingBlockedPaths.toggle()
						}) {
							Text("Blocked Paths")
						}
						.popover(isPresented: $showingBlockedPaths) {
							ScrollView {
								VStack(alignment: .leading) {
									ForEach(blockedPaths, id: \.self) { path in
										HStack {
											Text(path)
											Spacer()
											Button(action: {
												if let index = blockedPaths.firstIndex(of: path) {
													blockedPaths.remove(at: index)
												}
											}) {
												Image(systemName: "minus")
											}
										}
									}
								}
							}
							.padding()
							
							Button(action: {
								// Set up the open panel.
								let openPanel = NSOpenPanel()
								openPanel.canChooseDirectories = true
								openPanel.allowsMultipleSelection = true
								openPanel.begin(completionHandler: { response in
									if response == .OK {
										// Get the selected urls.
										let urls = openPanel.urls
										for url in urls {
											// Append the URL's path.
											blockedPaths.append(url.path)
										}
									}
								})
							}) {
								Image(systemName: "plus")
							}
							.padding([.bottom, .leading, .trailing])
						}
						Stepper("Icon Width: \(iconWidth)", value: $iconWidth)
						Stepper("Icon Height: \(iconHeight)", value: $iconHeight)
						Stepper("Result Item Height: \(resultItemHeight, specifier: "%g")", value: $resultItemHeight)
						Stepper("Result Item Limit: \(resultItemLimit)", value: $resultItemLimit)
						Toggle("Animated Navigation", isOn: $shouldAnimateNavigation)
						ColorPicker("Selected Item Background Color", selection: $selectedItemBackgroundColor)
					}
				}
			}
			
			Spacer()
			HStack {
				Spacer()
				Button("Save") {
					// Create a configuration with all settings.
					let newConfiguration = Configuration(backgroundColor: backgroundColor.hexString, textColor: textColor.hexString, activationKeyboardShortcut: activationKeyboardShortcut, searchBarFontSize: searchBarFontSize, searchBarHeight: searchBarHeight, insertionPointColor: insertionPointColor.hexString, maxHeight: maximumHeight, shouldAnimateText: shouldAnimateText, showingIcons: showingIcons, iconSizeWidth: iconWidth, iconSizeHeight: iconHeight, blockedPaths: blockedPaths, resultItemHeight: resultItemHeight, itemLimit: resultItemLimit, shouldAnimateNavigation: shouldAnimateNavigation, selectedItemBackgroundColor: selectedItemBackgroundColor.hexString)
					
					// Write the new configuration to the configuration path.
					newConfiguration.write()
					
					// Configure an alert.
					// The alert should tell the user that the app needs to restart so the changes get applied.
					let alert = NSAlert()
					alert.messageText = "Applying Changes"
					alert.informativeText = "Snap needs to restart to apply the changes."
					
					alert.addButton(withTitle: "Restart")
					alert.addButton(withTitle: "Continue")
					
					let appDelegate = NSApp.delegate as! AppDelegate
					
					// Unwrap the settings window.
					guard let settingsWindow = appDelegate.settingsWindow else { return }
					
					// Show the alert.
					alert.beginSheetModal(for: settingsWindow, completionHandler: { response in
						// If the user want's to restart the application, then...
						if response == .alertFirstButtonReturn {
							// Restart the application.
							guard let applicationURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.techris.Snap") else {
								// If the application url doesn't exist, then return. This should never happen.
								return
							}
							
							let task = Process()
							task.launchPath = "/usr/bin/open"
							task.arguments = [applicationURL.path]
							task.launch()
							
							NSApp.terminate(nil)
						} else {
							// Close the settings window.
							settingsWindow.close()
						}
					})
				}
				.padding()
			}
		}
		.padding(.leading)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

// SettingsView.swift
//
// Created by TeChris on 17.03.21.

import SwiftUI

struct SettingsView: View {
	static private let configuration = Configuration.decoded
	
	// General Settings
	@State private var backgroundColor = configuration.backgroundColor.color
	@State private var textColor = configuration.textColor.color
	@State private var activationKeyboardShortcut = configuration.activationKeyboardShortcut
	@State private var maximumWdith = configuration.maximumWidth
	@State private var maximumHeight = configuration.maximumHeight
	
	// Search bar settings
	@State private var searchBarFont = configuration.searchBarFont
	@State private var searchBarHeight = configuration.searchBarHeight
	@State private var insertionPointColor = configuration.insertionPointColor.color
	
	// Result settings
	@State private var showingIcons = configuration.showingIcons
	@State private var blockedPaths = configuration.blockedPaths
	@State private var iconWidth = configuration.iconSizeWidth
	@State private var iconHeight = configuration.iconSizeHeight
	@State private var resultItemFont = configuration.resultItemFont
	@State private var resultItemHeight = configuration.resultItemHeight
	@State private var resultItemLimit = configuration.resultItemLimit
	@State private var shouldAnimateNavigation = configuration.shouldAnimateNavigation
	@State private var selectedItemBackgroundColor = configuration.selectedItemBackgroundColor.color
	@State private var quickLookKeyboardShortcut = configuration.quickLookKeyboardShortcut
	
	// Clipboard history settings
	@State private var clipboardHistoryEnabled = configuration.clipboardHistoryEnabled
	@State private var historyItemLimit = configuration.historyItemLimit
	
	// The state of the "Blocked Paths" popover.
	@State private var showingBlockedPaths = false
	
	var body: some View {
		VStack {
			Text("Settings")
				.font(.largeTitle)
				.fontWeight(.bold)
				.padding(.top)
			
			ScrollView {
				SettingsSection(text: "General") {
					ColorPicker("Background Color", selection: $backgroundColor)
					ColorPicker("Text Color", selection: $textColor)
					KeyboardShortcutView(keyboardShortcut: $activationKeyboardShortcut) {
						Text("Activation Shortcut:")
					}
					Slider(value: $maximumWdith, in: 20...1000) {
						Text("Maximum Window Height: \(maximumWdith, specifier: "%.0f")")
							.padding(.trailing, 7.5)
					}
					.padding(.trailing, 12.5)
					.frame(maxWidth: 435)
					Slider(value: $maximumHeight, in: 20...1000) {
						Text("Maximum Window Height: \(maximumHeight, specifier: "%.0f")")
							.padding(.trailing, 7.5)
					}
					.padding(.trailing, 12.5)
					.frame(maxWidth: 435)
				}
				
				SettingsSection(text: "Search Bar") {
					FontPickerView(font: $searchBarFont)
					Stepper("Height: \(searchBarHeight, specifier: "%g")", value: $searchBarHeight)
					ColorPicker("Insertion Point Color", selection: $insertionPointColor)
				}
				
				SettingsSection(text: "Results") {
					Toggle("Showing Icons", isOn: $showingIcons)
					Button(action: {
						showingBlockedPaths.toggle()
					}) {
						Text("Blocked Paths")
					}
					.popover(isPresented: $showingBlockedPaths) {
						ScrollView {
							
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
					FontPickerView(font: $resultItemFont)
					Stepper("Result Item Height: \(resultItemHeight, specifier: "%g")", value: $resultItemHeight)
					Stepper("Result Item Limit: \(resultItemLimit)", value: $resultItemLimit)
					Toggle("Animated Navigation", isOn: $shouldAnimateNavigation)
					ColorPicker("Selected Item Background Color", selection: $selectedItemBackgroundColor)
					KeyboardShortcutView(keyboardShortcut: $quickLookKeyboardShortcut) {
						Text("Quick Look Shortcut:")
					}
				}
				SettingsSection(text: "Clipboard History") {
					Toggle("Enabled", isOn: $clipboardHistoryEnabled)
					Stepper("Item Limit: \(historyItemLimit)", value: $historyItemLimit)
				}
			}
			
			Spacer()
			HStack {
				Spacer()
				Button("Save") {
					// Create a configuration with all settings.
					let newConfiguration = Configuration(backgroundColor: backgroundColor.hexString, textColor: textColor.hexString, activationKeyboardShortcut: activationKeyboardShortcut, maximumWidth: maximumWdith, maximumHeight: maximumHeight, searchBarFont: searchBarFont, searchBarHeight: searchBarHeight, insertionPointColor: insertionPointColor.hexString, showingIcons: showingIcons, blockedPaths: blockedPaths, iconSizeWidth: iconWidth, iconSizeHeight: iconHeight, resultItemFont: resultItemFont, resultItemHeight: resultItemHeight, resultItemLimit: resultItemLimit, shouldAnimateNavigation: shouldAnimateNavigation, selectedItemBackgroundColor: selectedItemBackgroundColor.hexString, quickLookKeyboardShortcut: quickLookKeyboardShortcut, clipboardHistoryEnabled: clipboardHistoryEnabled, historyItemLimit: historyItemLimit)
					
					// Write the new configuration to the configuration path.
					newConfiguration.write()
					
					// Configure an alert.
					// The alert should tell the user that the app needs to restart so the changes get applied.
					let alert = NSAlert()
					alert.messageText = "Applying Changes"
					alert.informativeText = "Snap needs to restart to apply the changes."
					
					alert.addButton(withTitle: "Restart")
					alert.addButton(withTitle: "Continue")
					
					// Unwrap the settings window.
					guard let settingsWindow = Snap.default.settingsWindow else { return }
					
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

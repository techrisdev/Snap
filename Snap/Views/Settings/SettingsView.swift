// SettingsView.swift
//
// Created by TeChris on 17.03.21.

import SwiftUI

struct SettingsView: View {
	static private var configuration = Configuration.decoded
	
	@State private var backgroundColor = Color.fromHexString(configuration.backgroundColor)
	@State private var textColor = Color.fromHexString(configuration.textColor)
	@State private var activationKeyboardShortcut = configuration.activationKeyboardShortcut
	@State private var searchBarFontSize = configuration.searchBarFontSize
	@State private var searchBarHeight = configuration.searchBarHeight
	@State private var maximumHeight = configuration.maxHeight
	@State private var shouldAnimateText = configuration.shouldAnimateText
	@State private var showingIcons = configuration.showingIcons
	@State private var iconWidth = configuration.iconSizeWidth
	@State private var iconHeight = configuration.iconSizeHeight
	@State private var blockedPaths = configuration.blockedPaths
	@State private var resultItemHeight = configuration.resultItemHeight
	@State private var resultItemLimit = configuration.itemLimit
	@State private var shouldAnimateNavigation = configuration.shouldAnimateNavigation
	@State private var selectedItemBackgroundColor = configuration.selectedItemBackgroundColor
	
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
							.font(.title2)
						ColorPicker("Text Color", selection: $textColor)
							.font(.title2)
						KeyboardShortcutView(keyboardShortcut: $activationKeyboardShortcut) {
							Text("Activation Shortcut")
								.font(.title2)
						}
					}
				}
				
				SettingsSection(text: "Search Bar") {
					Text("Placeholder")
				}
			}
			
			Spacer()
			HStack {
				Spacer()
				Button("Save") {
					// Create a configuration with all settings.
					let newConfiguration = Configuration(backgroundColor: backgroundColor.hexString, textColor: textColor.hexString, activationKeyboardShortcut: activationKeyboardShortcut, searchBarFontSize: searchBarFontSize, searchBarHeight: searchBarHeight, maxHeight: maximumHeight, shouldAnimateText: shouldAnimateText, showingIcons: showingIcons, iconSizeWidth: iconWidth, iconSizeHeight: iconHeight, blockedPaths: blockedPaths, resultItemHeight: resultItemHeight, itemLimit: resultItemLimit, shouldAnimateNavigation: shouldAnimateNavigation, selectedItemBackgroundColor: selectedItemBackgroundColor)
					
					// Write the new configuration to the configuration path.
					newConfiguration.write()
				}
				.padding()
			}
		}
		.padding(.leading)
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

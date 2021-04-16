// PreferencesView.swift
//
// Created by TeChris on 17.03.21.

import SwiftUI

struct PreferencesView: View {
	static private let configuration = Configuration.decoded
	
	// General preferences
	@State private var backgroundColor = configuration.backgroundColor.color
	@State private var textColor = configuration.textColor.color
	@State private var activationKeyboardShortcut = configuration.activationKeyboardShortcut
	@State private var maximumWdith = configuration.maximumWidth
	@State private var maximumHeight = configuration.maximumHeight
	
	// Search bar preferences
	@State private var searchBarFont = configuration.searchBarFont
	@State private var searchBarHeight = configuration.searchBarHeight
	@State private var insertionPointColor = configuration.insertionPointColor.color
	
	// Search Result preferences
	@State private var showingIcons = configuration.showingIcons
	@State private var blockedPaths = configuration.blockedPaths
	@State private var iconWidth = configuration.iconSizeWidth
	@State private var iconHeight = configuration.iconSizeHeight
	@State private var resultItemFont = configuration.resultItemFont
	@State private var resultItemHeight = configuration.resultItemHeight
	@State private var resultItemLimit = configuration.resultItemLimit
	@State private var shouldAnimateNavigation = configuration.shouldAnimateNavigation
	@State private var selectedItemBackgroundColor = configuration.selectedItemBackgroundColor.color
	@State private var showPathKeyboardShortcut = configuration.showPathKeyboardShortcut
	@State private var quickLookKeyboardShortcut = configuration.quickLookKeyboardShortcut
	
	// Clipboard History preferences
	@State private var clipboardHistoryEnabled = configuration.clipboardHistoryEnabled
	@State private var historyItemLimit = configuration.historyItemLimit
	
	// Snippet Expansion preferences
	@State private var snippetExpansionEnabled = configuration.snippetExpansionEnabled
	@State private var snippets = configuration.snippets
	
	@State private var selectedView: Int? = 0
	
	var body: some View {
		
		NavigationView {
			List {
				NavigationLink(destination: GeneralSectionView(backgroundColor: $backgroundColor, textColor: $textColor, activationKeyboardShortcut: $activationKeyboardShortcut, maximumWdith: $maximumWdith, maximumHeight: $maximumHeight), tag: 0, selection: $selectedView) {
					Label("General", systemImage: "gearshape")
				}
				NavigationLink(destination: SearchBarSectionView(searchBarFont: $searchBarFont, searchBarHeight: $searchBarHeight, insertionPointColor: $insertionPointColor)) {
					Label("Search Bar", systemImage: "textformat")
				}
				NavigationLink(destination: SearchResultsSectionView(showingIcons: $showingIcons, blockedPaths: $blockedPaths, iconWidth: $iconWidth, iconHeight: $iconHeight, resultItemFont: $resultItemFont, resultItemHeight: $resultItemHeight, resultItemLimit: $resultItemLimit, shouldAnimateNavigation: $shouldAnimateNavigation, selectedItemBackgroundColor: $selectedItemBackgroundColor, showPathKeyboardShortcut: $showPathKeyboardShortcut, quickLookKeyboardShortcut: $quickLookKeyboardShortcut)) {
					Label("Search Results", systemImage: "magnifyingglass")
				}
				NavigationLink(destination: ClipboardHistorySectionView(clipboardHistoryEnabled: $clipboardHistoryEnabled, historyItemLimit: $historyItemLimit)) {
					Label("Clipboard History", systemImage: "bookmark")
				}
				NavigationLink(destination: SnippetExpansionSectionView(snippetExpansionEnabled: $snippetExpansionEnabled, snippets: $snippets)) {
					Label("Snippet Expansion", systemImage: "bolt")
				}
			}
			.listStyle(SidebarListStyle())
			.frame(minWidth: 175)
		}
		.onReceive(NotificationCenter.default.publisher(for: PreferencesWindow.preferencesWindowWillCloseNotification)) { _ in
			// Save the new configuration.
			save()
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		HStack {
			// MARK: TODO: Add a "Reset" button.
			Spacer()
			Button("Save") {
				save()
			}
			.padding([.bottom, .trailing])
		}
	}
	
	func save() {
		// Create a configuration with all preferences.
		let newConfiguration = Configuration(backgroundColor: backgroundColor.hexString, textColor: textColor.hexString, activationKeyboardShortcut: activationKeyboardShortcut, maximumWidth: maximumWdith, maximumHeight: maximumHeight, searchBarFont: searchBarFont, searchBarHeight: searchBarHeight, insertionPointColor: insertionPointColor.hexString, showingIcons: showingIcons, blockedPaths: blockedPaths, iconSizeWidth: iconWidth, iconSizeHeight: iconHeight, resultItemFont: resultItemFont, resultItemHeight: resultItemHeight, resultItemLimit: resultItemLimit, shouldAnimateNavigation: shouldAnimateNavigation, selectedItemBackgroundColor: selectedItemBackgroundColor.hexString, showPathKeyboardShortcut: showPathKeyboardShortcut, quickLookKeyboardShortcut: quickLookKeyboardShortcut, clipboardHistoryEnabled: clipboardHistoryEnabled, historyItemLimit: historyItemLimit, snippetExpansionEnabled: snippetExpansionEnabled, snippets: snippets)
		
		// Write the new configuration to the configuration path.
		newConfiguration.write()
		
		// Configure an alert.
		// The alert should tell the user that the app needs to restart so the changes get applied.
		let alert = NSAlert()
		alert.messageText = "Applying Changes"
		alert.informativeText = "Snap needs to restart to apply the changes."
		
		alert.addButton(withTitle: "Restart")
		alert.addButton(withTitle: "Continue")
		
		// Unwrap the preferences window.
		guard let preferencesWindow = Snap.default.preferencesWindow else { return }
		
		// Show the alert.
		alert.beginSheetModal(for: preferencesWindow) { response in
			// If the user want's to restart the application, then...
			if response == .alertFirstButtonReturn {
				// Relaunch the app.
				let path = Bundle.main.bundlePath
				let process = Process()
				process.launchPath = "/usr/bin/open"
				process.arguments = [path]
				process.launch()
				
				exit(0)
			} else {
				// Close the preferences window.
				preferencesWindow.closeWindow()
			}
		}
	}
}

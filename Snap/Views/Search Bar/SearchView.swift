// SearchView.swift
//
// Created by TeChris on 08.03.21.

import SwiftUI

struct SearchView: View {
	@ObservedObject private var search = Search()
	
	@State private var selectedItemIndex = 0
	@State private var text = ""
	@State private var showingPath = false
	@State private var application: ApplicationSearchItem? = nil
	
	@State private var itemAction: (SearchItem) -> Void = { _ in }
	
	private let configuration = Configuration.decoded
	private let notificationCenter = NotificationCenter.default
	private let snap = Snap.default
	private let quickLook = QuickLook(filePath: "")
	
	var body: some View {
		ZStack {
			configuration.backgroundColor.color
			
			if application == nil {
				VStack {
					SearchBarView(text: $text)
					SearchResultView(results: search.results, itemAction: itemAction, selectedItemIndex: selectedItemIndex, showingPath: $showingPath)
				}
				.onChange(of: text) { _ in
					// If the text doesn't contain any characters, then...
					if text.count == 0 {
						// Stop the search.
						search.stopSearch()
						
						// Clear the results array so no results get displayed.
						search.results = [SearchItem]()
						
						// Return from the Closure.
						return
					}
					
					// Reset the application.
					application = nil
					
					// Reset the selected item.
					selectedItemIndex = 0
					
					// If there are more than 0 characters, then search for the string.
					search.searchForString(text)
				}
				.onReceive(notificationCenter.publisher(for: .ReturnKeyWasPressed)) { _ in
					// Execute the selected item's action.
					if search.results.indices.contains(selectedItemIndex) {
						itemAction(selectedItem)
					}
				}
				.onReceive(notificationCenter.publisher(for: .UpArrowKeyWasPressed)) { _ in
					let newIndex = selectedItemIndex - 1
					
					// Update the selected item.
					updateSelectedItemIndex(to: newIndex)
				}
				.onReceive(notificationCenter.publisher(for: .DownArrowKeyWasPressed)) { _ in
					let newIndex = selectedItemIndex + 1
					
					// Update the selected item.
					updateSelectedItemIndex(to: newIndex)
				}
				.onReceive(notificationCenter.publisher(for: .TabKeyWasPressed)) { _ in
					// If the search result contains the currently selected item, Complete the current search item.
					if search.results.indices.contains(0) {
						text = search.results[selectedItemIndex].title
						
						// If the currently selected item accepts arguments, then append a space at the end, so the user can start typing arguments immediately.
						if search.results[selectedItemIndex].acceptsArguments {
							text += " "
						}
					}
				}
				.onReceive(notificationCenter.publisher(for: .ShouldPresentQuickLook)) { _ in
					// Open a preview panel.
					if let path = (selectedItem as? SpotlightSearchItem)?.path {
						quickLook.filePath = path
						quickLook.present()
					}
				}
				.onReceive(notificationCenter.publisher(for: QuickLook.panelWillCloseNotification)) { _ in
					// Stop listening for notifications.
					quickLook.stopObserving()
					
					// Activate the search window.
					snap.activate()
				}
			}
			
			application?.view
		}
		.onReceive(notificationCenter.publisher(for: .ApplicationShouldExit)) { _ in
			// When the current application should exit, then set it to nil.
			application = nil
		}
		.frame(height: !search.results.isEmpty ? configuration.maximumHeight : configuration.searchBarHeight)
		.frame(maxWidth: .infinity, maxHeight: search.results.isEmpty ? configuration.searchBarHeight : .infinity)
		.onAppear {
			// Add a monitor for key events to get notified when certain keys get pressed.
			snap.addKeyboardMonitor()
			
			// Create the item action.
			itemAction = { item in
				// If the item doesn't accept arguments, then give it the whole string.
				let currentSearchArguments = item.acceptsArguments ? self.currentSearchArguments : text
				
				// If the path is shown, then open the path in Finder. If it isn't, then do the default action for the item.
				if !showingPath {
					// If the item is an application item, then display the view.
					if let applicationItem = item as? ApplicationSearchItem {
						application = applicationItem
						return
					}
					
					// If another application will be activated, deactivate Snap.
					snap.deactivate()
					
					// If the item is a Spotlight Search Item, execute the item's action on another thread.
					if item as? SpotlightSearchItem != nil {
						DispatchQueue.global(qos: .userInteractive).async {
							item.action(currentSearchArguments)
						}
					} else {
						// Execute the item's action.
						item.action(currentSearchArguments)
					}
				} else {
					// Open the URL in Finder.
					NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: item.path)])
				}
			}
		}
	}
	
	// The currently selected item.
	private var selectedItem: SearchItem {
		search.results[selectedItemIndex]
	}
	
	private var currentSearchArguments: String {
		let textSplitBySpaces = text.components(separatedBy: .whitespaces)
		
		if textSplitBySpaces.indices.contains(1) {
			// Drop the search item.
			let argumentArray = textSplitBySpaces.dropFirst()
			
			var result = ""
			
			// Go through the arguments.
			for argument in argumentArray {
				// If the argument isn't the first argument, then append a space to the string.
				if !result.isEmpty {
					result.append(" ")
				}
				
				// Append the argument.
				result.append(argument)
			}
			
			return result
		}
		
		// If the search doesn't contain an argument, then return an empty string.
		return ""
	}
	
	private func updateSelectedItemIndex(to index: Int) {
		// If the Array doesn't contain the newIndex, then return from the function.
		if !search.results.indices.contains(index) {
			return
		}
		
		// If the item exists, update the selected item.
		withAnimation(configuration.shouldAnimateNavigation ? .default : .none) {
			selectedItemIndex = index
		}
	}
}

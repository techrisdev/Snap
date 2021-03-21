// SearchView.swift
//
// Created by TeChris on 08.03.21.

import SwiftUI

struct SearchView: View {
	@ObservedObject var search = Search()
	
	@State private var selectedItemIndex = 0
	@State private var text = ""
	@State private var showingPath = false
	@State private var application: ApplicationSearchItem? = nil
	
	let configuration = Configuration.decoded
	let notificationCenter = NotificationCenter.default
	var body: some View {
		VStack {
			ZStack {
				Color.fromHexString(configuration.backgroundColor)
				
				if application == nil {
					VStack {
						SearchBarView(text: $text)
						SearchResultView(results: search.results, selectedItemIndex: selectedItemIndex, text: text, currentSearchArguments: currentSearchArguments, showingPath: $showingPath)
					}
				}
					
				application?.view
			}
		}
		.frame(height: !search.results.isEmpty ? configuration.maxHeight : configuration.searchBarHeight)
		.frame(maxWidth: .infinity, maxHeight: search.results.isEmpty ? configuration.searchBarHeight : .infinity)
		.onChange(of: text, perform: { _ in
			// If the text doesn't contain any characters, then...
			if text.count == 0 {
				// Stop the search.
				search.stopSearch()
				
				// Empty the results so no results get displayed.
				search.results = [SearchItem]()
				
				// Return from the Closure.
				return
			}
			
			// If there are more than 0 characters, then search for the string.
			search.startSearchForString(text)
			
			// Reset the application.
			application = nil
			
			// Reset the selected item.
			selectedItemIndex = 0
		})
		.onReceive(NotificationCenter.default.publisher(for: .ReturnKeyWasPressed)) { _ in
			// When the return key was pressed, then open the selected item.
			if search.results.indices.contains(selectedItemIndex) {
				// If an action gets executed, then deactivate the application.
				Snap.standard.deactivate()
				
				let selectedItem = search.results[selectedItemIndex]
				
				// If the item doesn't accept arguments, then give it the whole string.
				let currentSearchArguments = selectedItem.acceptsArguments ? self.currentSearchArguments : text
				
				// If the path is shown, then open the path in Finder. If it isn't, then do the default action for the item.
				if !showingPath {
					// If the item is a web search item, then do then check if the item takes its name as an argument.
					if let webSearchItem = selectedItem as? WebSearchItem {
						if webSearchItem.takesNameAsArgument {
							webSearchItem.action(selectedItem.name)
							return
						}
					}
					
					// If the item is an application item, then display the view.
					if let applicationItem = selectedItem as? ApplicationSearchItem {
						application = applicationItem
						return
					}
					
					// Execute the item's action.
					selectedItem.action(currentSearchArguments)
				} else {
					// Open the URL in Finder.
					NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: selectedItem.path)])
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .UpArrowKeyWasPressed)) { _ in
			let newIndex = selectedItemIndex - 1
			
			// Update the selected item.
			updateSelectedItemIndex(to: newIndex)
		}
		.onReceive(NotificationCenter.default.publisher(for: .DownArrowKeyWasPressed)) { _ in
			let newIndex = selectedItemIndex + 1
			
			// Update the selected item.
			updateSelectedItemIndex(to: newIndex)
		}
		.onReceive(NotificationCenter.default.publisher(for: .TabKeyWasPressed)) { _ in
			// If the search result contains the currently selected item, Complete the current search item.
			if search.results.indices.contains(0) {
				text = search.results[selectedItemIndex].name
				
				// If the currently selected item accepts arguments, then append a space at the end, so the user can start typing arguments immediately.
				if search.results[selectedItemIndex].acceptsArguments {
					text += " "
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .ApplicationShouldExit), perform: { _ in
			// When the current application should exit, then set it to nil.
			application = nil
		})
		.onAppear(perform: {
			// Add a monitor for key events to get notified when certain keys get pressed.
			NSEvent.addSnapKeyboardMonitor()
		})
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
		
		// If the Array contains the new index, then set the index to the new index.
		withAnimation(configuration.shouldAnimateNavigation ? .default : .none) {
			selectedItemIndex = index
		}
	}
}

struct SearchView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView()
	}
}

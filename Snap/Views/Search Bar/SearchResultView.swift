// SearchResultView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI
import Carbon.HIToolbox.Events

struct SearchResultView: View {
	@State private var scrollViewID = UUID()
	
	var results: [SearchItem]
	var itemAction: (SearchItem) -> Void
	var selectedItemIndex: Int
	
	@Binding var showingPath: Bool
	
	let configuration = Configuration.decoded
	var body: some View {
		ScrollView {
			ScrollViewReader { value in
				ForEach(results, id: \.id) { item in
					Button(action: {
						// Execute the action.
						itemAction(item)
					}) {
						SearchItemView(item: item, isSelectedItem: item.firstIndexInArray(results) == selectedItemIndex, isShowingPath: showingPath)
					}
					.id(item.id)
					.frame(height: configuration.resultItemHeight)
					.buttonStyle(PlainButtonStyle())
					
				}
				.onChange(of: results.first?.id) { _ in
					// When the results change, Scroll to the top.
					scrollViewID = UUID()
				}
				.onChange(of: selectedItemIndex) { _ in
					// Check if the selected item exists; If it does, then scroll down to the item.
					if results.indices.contains(selectedItemIndex) {
						value.scrollTo(results[selectedItemIndex].id, anchor: .center)
					}
				}
			}
		}
		.id(scrollViewID)
		.onAppear {
			// Listen for an event (keyboard shortcut) to show the path and show the file in Finder (later) instead of opening the file.
			NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp]) { [configuration] event in
				let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
				if modifiers.keyboardShortcutModifiers == configuration.showPathKeyboardShortcut.modifiers && event.keyCode == configuration.showPathKeyboardShortcut.key.keyCode {
					if event.type == .keyDown {
						showingPath = true
					} else {
						showingPath = false
					}
					
					return nil
				}
				
				return event
			}
		}
	}
}

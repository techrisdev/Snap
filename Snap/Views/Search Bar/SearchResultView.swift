// SearchResultView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI
import Carbon

struct SearchResultView: View {
	var results: [SearchItem]
	var selectedItemIndex: Int
	var text: String
	var currentSearchArguments: String
	
	@Binding var showingPath: Bool
	
	let configuration = Configuration.decoded
	var body: some View {
		ScrollView {
			ScrollViewReader { value in
				ForEach(results, id: \.id) { item in
					Button(action: {
						let currentSearchArguments = item.acceptsArguments ? self.currentSearchArguments : text
						item.action(currentSearchArguments)
					}) {
						SearchItemView(item: item, isSelectedItem: item.firstIndexInArray(results) == selectedItemIndex, isShowingPath: showingPath)
					}
					.id(item.id)
					.frame(height: configuration.resultItemHeight)
					.buttonStyle(PlainButtonStyle())
					
				}
				.onChange(of: selectedItemIndex) { _ in
					// Check if the selected item exists; If it does, then scroll down to the item.
					if results.indices.contains(selectedItemIndex) {
						value.scrollTo(results[selectedItemIndex].id, anchor: .center)
					}
				}
			}
		}
		.onAppear {
			// Listen for an event (keyboard shortcut) to show the path and show the file in Finder (later) instead of opening the file.
			NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp], handler: { event in
				let modifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
				if modifiers == .command && event.keyCode == kVK_ANSI_F {
					if event.type == .keyDown {
						showingPath = true
					} else {
						showingPath = false
					}
					
					return nil
				}
				
				return event
			})
		}
	}
}
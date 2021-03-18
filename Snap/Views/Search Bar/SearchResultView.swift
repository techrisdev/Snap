// SearchResultView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI
import Carbon

struct SearchResultView: View {
	var results: [SearchItem]
	var selectedItemIndex: Int
	
	let configuration = Configuration.decoded
	let appDelegate = NSApp.delegate as! AppDelegate
	
	@Binding var showingPath: Bool
	var body: some View {
		ScrollView {
			ScrollViewReader { value in
				ForEach(results) { item in
					Button(action: {
						let currentSearchArguments = item.acceptsArguments ? appDelegate.window.currentSearchArguments : appDelegate.window.text
						item.action(currentSearchArguments)
					}) {
						SearchItemView(item: item, isSelectedItem: results.firstIndex(of: item) == selectedItemIndex, isShowingPath: showingPath)
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
			// Listen for a keyboard shortcut to show the path and show the file in Finder (later) instead of opening the file.
			let keyboardShortcutManager = KeyboardShortcutManager(keyboardShortcut: KeyboardShortcut(keyCode: kVK_ANSI_F, modifierFlags: [.command], events: [.keyDown, .keyUp]))
			keyboardShortcutManager.startListeningForEvents { event in
				if event == .keyDown {
					showingPath = true
				} else {
					showingPath = false
				}
			}
		}
	}
}

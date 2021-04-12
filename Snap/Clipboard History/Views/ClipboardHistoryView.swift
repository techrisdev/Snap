// ClipboardHistoryView.swift
//
// Created by TeChris on 05.04.21.

import SwiftUI
import Carbon.HIToolbox.Events

struct ClipboardHistoryView: View {
	@State private var selectedItemIndex = 0
	@State private var items = [ClipboardHistoryItem]()
	@State private var deleteKeyMonitor: Any!
	
	private let configuration = Configuration.decoded
	private let notificationCenter = NotificationCenter.default
	var body: some View {
		if items.count == 0 {
			Text("Your history is empty!")
				.font(configuration.resultItemFont.font)
		}
		HStack {
			ScrollView {
				ScrollViewReader { value in
					ForEach(items, id: \.id) { item in
						Button(action: {
							// Copy the data to the clipboard.
							copySelectedItemToClipboard()
						}) {
							ItemView(icon: nil, isSelectedItem: item.id == selectedItem.id) {
								if item.image != nil {
									Image(nsImage: item.image!)
										.resizable()
										.scaledToFit()
								} else if item.file != nil {
									Text(item.file!)
								} else if item.string != nil {
									Text(item.string!)
								}
							}
						}
						.id(item.id)
						.frame(height: configuration.resultItemHeight)
						.buttonStyle(PlainButtonStyle())
						
					}
					.onChange(of: selectedItemIndex) { _ in
						// Check if the selected item exists; If it does, then scroll down to the item.
						if items.indices.contains(selectedItemIndex) {
							value.scrollTo(items[selectedItemIndex].id, anchor: .center)
						}
					}
				}
			}
			.onReceive(notificationCenter.publisher(for: .ReturnKeyWasPressed), perform: { _ in
				// When the return key was pressed, then copy the selected item's data to the clipboard.
				copySelectedItemToClipboard()
			})
			.onReceive(notificationCenter.publisher(for: .UpArrowKeyWasPressed), perform: { _ in
				// Update the index with an animation..
				updateSelectedItemIndex(selectedItemIndex - 1)
			})
			.onReceive(notificationCenter.publisher(for: .DownArrowKeyWasPressed), perform: { _ in
				// Update the index with an animation..
				updateSelectedItemIndex(selectedItemIndex + 1)
			})
			.onReceive(notificationCenter.publisher(for: .ShouldDeleteClipboardHistoryItem), perform: { _ in
				// Delete the currently selected item.
				deleteSelectedItem()
			})
			.onReceive(notificationCenter.publisher(for: .ShouldDeleteClipboardHistory), perform: { _ in
				// Delete the clipboard history.
				// Create a new history without items.
				let newHistory = ClipboardHistory(items: [ClipboardHistoryItem]())
				
				// Write the new history to disk.
				newHistory.write()
				
				// Update the views items.
				items = newHistory.items
			})
			if items.count > 0 {
				VStack {
					HStack {
						Spacer()
						if selectedItem.image != nil {
							Image(nsImage: selectedItem.image!)
								.resizable()
								.scaledToFit()
						} else if selectedItem.file != nil {
							Text(selectedItem.file!)
								.font(configuration.resultItemFont.font)
								.foregroundColor(configuration.textColor.color)
						} else if selectedItem.string != nil {
							HStack {
								Text(selectedItem.string!)
									.font(configuration.resultItemFont.font)
									.foregroundColor(configuration.textColor.color)
							}
						}
						Spacer()
					}
					.frame(maxWidth: configuration.maximumWidth / 2)
					Spacer()
				}
			}
		}
		.onAppear {
			// Update the items. This is necessary, because for some reason, when the Application (ClipboardHistoryApp) gets deinitialized, and the user activates the history app again without updating the text, the items are still the old items from before.
			items = ClipboardHistory.decoded.items
			
			// Add a event monitor to check if the delete key was pressed.
			deleteKeyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: { event in
				if event.keyCode == kVK_Delete {
					// If the delete key was pressed, delete the currently selected item.
					self.deleteSelectedItem()
					return nil
				}
				
				return event
			})
		}
		.onDisappear {
			// When the view disappears, remove the delete key event monitor.
			NSEvent.removeMonitor(deleteKeyMonitor!)
		}
	}
	
	var selectedItem: ClipboardHistoryItem {
		return items[selectedItemIndex]
	}
	
	func updateSelectedItemIndex(_ index: Int) {
		// Check if an item with the new index is available.
		if items.indices.contains(index) {
			// Update the selected item with an animation..
			withAnimation(configuration.shouldAnimateNavigation ? .default : .none) {
				selectedItemIndex = index
			}
		}
	}
	
	func copySelectedItemToClipboard() {
		// Copy the selected item's data to the clipboard.
		let pasteboard = NSPasteboard.general
		if let image = selectedItem.image {
			pasteboard.declareTypes([.tiff], owner: nil)
			pasteboard.setData(image.tiffRepresentation, forType: .tiff)
		} else {
			pasteboard.declareTypes([.string], owner: nil)
			if let file = selectedItem.file {
				pasteboard.setData(file.data(using: .utf8), forType: .string)
			} else {
				pasteboard.setData(selectedItem.string?.data(using: .utf8), forType: .string)
			}
		}
		
		// Deactivate the application.
		Snap.default.deactivate()
	}
	
	func deleteSelectedItem() {
		// Check if the index is out of range.
		if !items.indices.contains(selectedItemIndex) {
			return
		}
		
		// Create a updated history.
		items.remove(at: selectedItemIndex)
		updateSelectedItemIndex(selectedItemIndex - 1)
		let newHistory = ClipboardHistory(items: items)
		
		// Write the new history to disk.
		newHistory.write()
	}
}

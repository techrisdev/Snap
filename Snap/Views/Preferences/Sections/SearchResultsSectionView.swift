// SearchResultsSectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct SearchResultsSectionView: View {
	@Binding var showingIcons: Bool
	@Binding var blockedPaths: [String]
	@Binding var iconWidth: Int
	@Binding var iconHeight: Int
	@Binding var resultItemFont: Font
	@Binding var resultItemHeight: CGFloat
	@Binding var resultItemLimit: Int
	@Binding var shouldAnimateNavigation: Bool
	@Binding var selectedItemBackgroundColor: Color
	@Binding var showPathKeyboardShortcut: KeyboardShortcut
	@Binding var quickLookKeyboardShortcut: KeyboardShortcut
	
	// The state of the "Blocked Paths" popover.
	@State private var showingBlockedPaths = false
	
    var body: some View {
		PreferencesSection(text: "Results") {
			Group {
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
						openPanel.begin { response in
							if response == .OK {
								// Get the selected urls.
								let urls = openPanel.urls
								for url in urls {
									// Append the URL's path.
									blockedPaths.append(url.path)
								}
							}
						}
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
			KeyboardShortcutView(keyboardShortcut: $showPathKeyboardShortcut) {
				Text("Show Path Shortcut:")
			}
		}
    }
}

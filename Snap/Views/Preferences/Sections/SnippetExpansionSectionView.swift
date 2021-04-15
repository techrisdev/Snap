// SnippetExpansionSectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct SnippetExpansionSectionView: View {
	@Binding var snippetExpansionEnabled: Bool
	@Binding var snippets: [Snippet]
	
	@State private var showingPopover = false
	@State private var newSnippet = Snippet(keyword: "", snippet: "")
	var body: some View {
		PreferencesSection(text: "Snippet Expansion") {
			Toggle("Enabled", isOn: $snippetExpansionEnabled)
				.padding(.bottom)
			HStack {
				Spacer()
				Text("Snippets")
					.font(.title2)
				Spacer()
			}
			VStack {
				ForEach(snippets, id: \.self) { snippet in
					HStack {
						VStack(alignment: .leading) {
							HStack {
								Text("Keyword: ")
									.foregroundColor(.secondary)
								Text(snippet.keyword)
							}
							HStack {
								Text("Snippet: " )
									.foregroundColor(.secondary)
								Text(snippet.snippet)
							}
						}
						Spacer()
						Button(action: {
							// Remove the snippet from the array.
							if let index = snippets.firstIndex(of: snippet) {
								snippets.remove(at: index)
							}
						}) {
							Image(systemName: "minus")
						}
					}
				}
			}
			.padding()
			HStack {
				Spacer()
				Button(action: {
					showingPopover.toggle()
				}) {
					Image(systemName: "plus")
				}
				.popover(isPresented: $showingPopover) {
					AddSnippetExpansionView(snippet: $newSnippet)
					Button("OK") {
						// Append the new snippet to the array.
						snippets.append(newSnippet)
						
						// Reset the new snippet.
						newSnippet = Snippet(keyword: "", snippet: "")
						
						// Close the popover.
						showingPopover = false
					}
				}
				Spacer()
			}
		}
	}
}

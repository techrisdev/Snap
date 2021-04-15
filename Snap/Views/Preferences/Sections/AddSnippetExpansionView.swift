// AddSnippetExpansionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct AddSnippetExpansionView: View {
	@Binding var snippet: Snippet
	var body: some View {
		VStack {
			TextField("Keyword", text: $snippet.keyword)
			TextField("Snippet", text: $snippet.snippet)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}

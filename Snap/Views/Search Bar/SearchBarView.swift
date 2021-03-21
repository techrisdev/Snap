// SearchBarView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct SearchBarView: View {
	@Binding var text: String
	
	let configuration = Configuration.decoded
	var body: some View {
		VStack {
			SearchTextField(text: $text)
		}
		.padding([.leading, .trailing], 5)
		.padding(.top)
		.frame(height: configuration.searchBarHeight)
	}
}

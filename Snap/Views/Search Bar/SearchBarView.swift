// SearchBarView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct SearchBarView: View {
	@Binding var text: String
	
	let configuration = Configuration.decoded
	var body: some View {
		VStack {
			Spacer()
			SearchTextField(text: $text)
		}
		// MARK: TODO - Maybe an option for changing this padding?
		.padding([.leading, .trailing], 10)
		.frame(height: configuration.searchBarHeight)
	}
}

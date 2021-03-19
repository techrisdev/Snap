// SearchBarView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct SearchBarView: View {
	@Binding var text: String
	
	let configuration = Configuration.decoded
	var body: some View {
		VStack {
			HStack {
				TextView(text: $text)
				Spacer()
			}
			.padding([.leading, .trailing, .top])
			.frame(height: configuration.searchBarHeight)
		}
	}
}

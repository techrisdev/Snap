// SearchBarView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct SearchBarView: View {
	var text: String
	
	let configuration = Configuration.decoded
	var body: some View {
		VStack {
			HStack {
				Text(text)
					.foregroundColor(Color.fromHexString(configuration.textColor))
					.font(.system(size: configuration.searchBarFontSize))
				
				Spacer()
			}
			.padding([.leading, .trailing, .top])
			.frame(height: configuration.searchBarHeight)
		}
	}
}

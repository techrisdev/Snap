// SearchItemView.swift
//
// Created by TeChris on 09.03.21.

import SwiftUI

struct SearchItemView: View {
	var item: SearchItem
	var isSelectedItem: Bool
	var isShowingPath: Bool
	
	let configuration = Configuration.decoded
	var body: some View {
		ZStack {
			ItemView(icon: item.icon, isSelectedItem: isSelectedItem) {
				Text(item.name)
			}
			
			if isSelectedItem, isShowingPath, let item = item as? SpotlightSearchItem {
				configuration.selectedItemBackgroundColor.color
				HStack {
					Text(item.path)
						.font(configuration.resultItemFont.font)
						.foregroundColor(configuration.textColor.color)
					Spacer()
				}
				.padding([.leading, .trailing], 5)
			}
		}
	}
}

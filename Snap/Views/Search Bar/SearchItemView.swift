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
			// If the item is the selected item, give it a background.
			if isSelectedItem {
				Color.fromHexString(configuration.selectedItemBackgroundColor)
					.frame(maxHeight: configuration.resultItemHeight)
			}
			
			VStack {
				HStack {
					if configuration.showingIcons {
						Image(nsImage: item.icon.image)
					}
					
					Spacer()
					Text(item.name)
						.font(.title3)
						.fontWeight(.semibold)
						.foregroundColor(Color.fromHexString(configuration.textColor))
					Spacer()
				}
				
				if isShowingPath {
					if let item = (item as? SpotlightSearchItem) {
						HStack {
							Text(item.path)
								.font(.system(size: 12))
								.foregroundColor(Color.fromHexString(configuration.textColor))
							Spacer()
						}
						.padding(.bottom, 3.5)
					}
				}
			}
			.padding()
		}
	}
}

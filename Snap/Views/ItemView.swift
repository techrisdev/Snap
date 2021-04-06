// ItemView.swift
//
// Created by TeChris on 05.04.21.

import SwiftUI

struct ItemView<Label> : View where Label : View {
	var icon: Icon?
	var isSelectedItem: Bool
	var label: () -> Label
	
	init(icon: Icon?, isSelectedItem: Bool, @ViewBuilder label: @escaping () -> Label) {
		self.icon = icon
		self.isSelectedItem = isSelectedItem
		self.label = label
	}
	
	private let configuration = Configuration.decoded
	var body: some View {
		ZStack {
			// If the item is the selected item, give it a background.
			if isSelectedItem {
				configuration.selectedItemBackgroundColor.color
			}
			
			VStack {
				HStack {
					if configuration.showingIcons, let icon = icon {
						Image(nsImage: icon.image)
					}
					
					Spacer()
					label()
						.font(configuration.resultItemFont.font)
						.foregroundColor(configuration.textColor.color)
					Spacer()
				}
			}
			.padding()
		}
	}
}

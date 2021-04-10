// SettingsSection.swift
//
// Created by TeChris on 18.03.21.

import SwiftUI

struct SettingsSection<Content> : View where Content : View {
	var text: String
	var content: () -> Content
	
	init(text: String, @ViewBuilder content: @escaping () -> Content) {
		self.text = text
		self.content = content
	}
	var body: some View {
		VStack {
			HStack {
				Text(text)
					.font(.title)
					.fontWeight(.semibold)
					.padding([.bottom, .top], 7.5)
				Spacer()
			}
			
			HStack {
				VStack(alignment: .leading) {
					content()
				}
				Spacer()
			}
		}
	}
}

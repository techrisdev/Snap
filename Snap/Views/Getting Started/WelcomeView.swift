// WelcomeView.swift
//
// Created by TeChris on 14.04.21.

import SwiftUI

struct WelcomeView: View {
	@Binding var screen: GettingStartedScreen
	var body: some View {
		VStack {
			Text("Welcome to Snap!")
				.font(.title)
				.fontWeight(.bold)
				.padding(.top)
			Snap.default.icon
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			Spacer()
			Text("There are a few steps needed before using Snap.")
				.foregroundColor(.secondary)
				.padding(.bottom, 25)
			VStack {
				HighlightedButton("Continue") {
					screen = .fullDiskAccess
				}
				.frame(width: 135)
				.padding(.bottom, 2.5)
				Button(action: {
					NSApp.terminate(nil)
				}) {
					Text("Quit")
						.frame(width: 120)
				}
			}
			.padding([.bottom, .leading, .trailing])
		}
		.padding()
	}
}

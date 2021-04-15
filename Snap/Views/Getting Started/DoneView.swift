// DoneView.swift
//
// Created by TeChris on 14.04.21.

import SwiftUI

struct DoneView: View {
	private let snap = Snap.default
    var body: some View {
		VStack {
			Text("Done!")
				.font(.title)
				.fontWeight(.bold)
			snap.icon
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			Spacer()
			Text("You can start using Snap. To activate Snap, hit 􀆕 + Space on your keyboard. For configuration options, you can click on the 􀊫 Menu Item and then the \"Preferences\" Button.")
				.padding()
			HighlightedButton("Start Using Snap") {
				UserDefaults.standard.setValue(true, forKey: "StartedBefore")
				snap.gettingStartedWindow.close()
				snap.start()
			}
			.frame(width: 135)
			.padding(.bottom, 2.5)
		}
		.padding()
    }
}

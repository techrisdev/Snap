// GettingStartedView.swift
//
// Created by TeChris on 14.04.21.

import SwiftUI

struct GettingStartedView: View {
	@State private var currentScreen: GettingStartedScreen = .welcome
	var body: some View {
		VStack {
			switch currentScreen {
			case .welcome:
				WelcomeView(screen: $currentScreen)
			case .fullDiskAccess:
				FullDiskAccessView(screen: $currentScreen)
			case .done:
				DoneView()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}
}


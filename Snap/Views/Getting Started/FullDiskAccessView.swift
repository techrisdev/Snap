// FullDiskAccessView.swift
//
// Created by TeChris on 14.04.21.

import SwiftUI
import AVKit

struct FullDiskAccessView: View {
	@Binding var screen: GettingStartedScreen
	var body: some View {
		VStack {
			Text("Full Disk Access")
				.font(.title)
				.fontWeight(.bold)
				.padding(.top)
			Spacer()
			LoopVideoPlayer(url: Bundle.main.url(forResource: "Allow Full Disk Access", withExtension: "mp4")!)
				.padding()
				.frame(width: 365, height: 325)
			Text("Snap needs Full Disk Access to access Files in the Home directory.")
				.padding(.bottom)
			Button("Open System Preferences") {
				NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
			}
			.padding(.bottom, 5)
			Button("Continue without Access") {
				screen = .accessibility
			}
			.foregroundColor(.blue)
			.buttonStyle(PlainButtonStyle())
		}
		.padding(25)
    }
}

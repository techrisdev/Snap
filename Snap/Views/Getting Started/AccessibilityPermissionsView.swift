// AccessibilityPermissionsView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI
import AVKit

struct AccessibilityPermissionsView: View {
	@Binding var screen: GettingStartedScreen
	
	@State private var waiting = false
	var body: some View {
		if !waiting {
			VStack {
				Text("Accessibility Permissions")
					.font(.title)
					.fontWeight(.bold)
					.padding(.top)
				Spacer()
				LoopVideoPlayer(url: Bundle.main.url(forResource: "Grant Accessibility Permissions", withExtension: "mp4")!)
					.padding()
					.frame(width: 365, height: 325)
				Spacer()
				Text("Snap needs Accessibility Permissions to provide features like Snippet Expansion.")
				Button("Ask for Permissions") {
					// Present a dialog asking for Accessibility permissions.
					let options: CFDictionary = NSDictionary(dictionary: [kAXTrustedCheckOptionPrompt.takeRetainedValue(): true])
					AXIsProcessTrustedWithOptions(options)
					
					// Present a progress view.
					waiting = true
				}
				.padding(.bottom, 5)
				Button("Continue without Permissions") {
					screen = .done
				}
				.foregroundColor(.blue)
				.buttonStyle(PlainButtonStyle())
			}
			.padding()
		} else {
			ProgressView("Waiting for Permissions...")
				.onAppear {
					if !AXIsProcessTrusted() {
						waitUntilProcessIsTrusted()
					} else {
						// If the process is already trusted, go to the next screen.
						screen = .done
					}
				}
		}
	}
	
	/// Wait until Accessibility permissions are granted.
	func waitUntilProcessIsTrusted() {
		DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.85) {
			// Check if the process is trusted.
			if !AXIsProcessTrusted() {
				// If it isn't, continue waiting.
				waitUntilProcessIsTrusted()
			} else {
				// If the process is trusted, go to the next screen.
				DispatchQueue.main.async {
					// Set the current screen to the "Done" screen on the main thread.
					screen = .done
				}
			}
		}
	}
}

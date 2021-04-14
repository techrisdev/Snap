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
			LoopVideoPlayer(url: Bundle.main.url(forResource: "Allow Full Disk Access.mp4", withExtension: nil)!)
				.padding()
				.frame(width: 365, height: 325)
			Text("Snap needs Full Disk Access to access Files in the Home directory.")
				.padding(.bottom)
			Button("Open System Preferences") {
				NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!)
			}
			.padding(.bottom, 5)
			Button("Continue without Access") {
				screen = .done
			}
			.foregroundColor(.blue)
			.buttonStyle(PlainButtonStyle())
		}
		.padding()
    }
	private struct LoopVideoPlayer: NSViewRepresentable {
		/// The player's url.
		var url: URL
		
		func makeNSView(context: Context) -> NSView {
			return VideoPlayerNSView(url: url)
		}
		
		func updateNSView(_ nsView: NSView, context: Context) {
			
		}
		
		private class VideoPlayerNSView: NSView {
			private let playerLayer = AVPlayerLayer()
			
			var url: URL
			
			init(url: URL) {
				self.url = url
				
				super.init(frame: .zero)
				
				// Create a player with the url.
				let player = AVPlayer(url: url)
				player.play()
				
				// Configure the player layer.
				playerLayer.videoGravity = .resizeAspectFill
				playerLayer.player = player
				
				if layer == nil {
					layer = CALayer()
				}
				
				layer?.addSublayer(playerLayer)
				
				// When the player plays to the end, start it again from the beginning.
				NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { _ in
					player.seek(to: .zero)
					player.play()
				}
			}
			
			required init?(coder: NSCoder) {
				fatalError("init(coder:) has not been implemented")
			}
			
			override func layout() {
				super.layout()
				playerLayer.frame = bounds
			}
		}
	}
}

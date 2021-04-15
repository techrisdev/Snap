// LoopVideoPlayer.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI
import AVKit

struct LoopVideoPlayer: NSViewRepresentable {
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

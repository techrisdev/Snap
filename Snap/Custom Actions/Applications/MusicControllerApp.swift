// MusicControllerApp.swift
//
// Created by TeChris on 13.03.21.

import SwiftUI
import ScriptingBridge

@objc protocol MusicApplication {
	func currentTrack() -> AnyObject
	var artworks: NSArray { get }
}

class MusicControllerApp: ApplicationSearchItem {
	init() {
		super.init(name: "Music Controller")
	}
	
	override var view: ApplicationView {
		return ApplicationView(content: AnyView(MusicControllerView()))
	}
	
	struct MusicControllerView: View {
		let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
		let configuration = Configuration.decoded
		
		@State private var currentSong = Song()
		var body: some View {
			VStack {
				Image(nsImage: currentSong.artwork)
					.resizable()
					.frame(width: 150, height: 150)
				Spacer()
				Text(currentSong.name)
					.font(.title)
					.fontWeight(.semibold)
					.foregroundColor(Color.fromHexString(configuration.textColor))
				Text(currentSong.artist + " - " + currentSong.album)
					.font(.title3)
					.foregroundColor(Color.fromHexString(configuration.textColor))
				Button(action: {
					currentSong.stop()
				}) {
					Image(systemName: "playpause")
				}
				Spacer()
			}
			.onReceive(timer, perform: { _ in
				currentSong = Song()
			})
			
			Spacer()
		}
	}
	
	struct Song {
		var name: String
		var album: String
		var artist: String
		var artwork: NSImage
		
		init() {
			let app: AnyObject = SBApplication(bundleIdentifier: "com.apple.music")!
			
			name = app.currentTrack().properties["name"] as? String ?? ""
			album = app.currentTrack().properties["album"] as? String ?? ""
			artist = app.currentTrack().properties["artist"] as? String ?? ""
			artwork = (app.currentTrack().artworks[0] as AnyObject).properties["data"] as? NSImage ?? NSImage()
		}
		
		func stop() {
			AppleScript.executeByTellingSystemEvents(string: "tell application \"Music\" to playpause")
		}
	}
}

// MusicControllerApp.swift
//
// Created by TeChris on 13.03.21.

import SwiftUI
import ScriptingBridge

@objc protocol MusicApplication {
	func currentTrack() -> AnyObject
	var artworks: NSArray { get }
}

struct MusicControllerApp: ApplicationSearchItem {
	let id = UUID()
	
	let acceptsArguments = false
	
	let title = "Music Controller"
	
	let view = ApplicationView(content: AnyView(MusicControllerView()))
	
	struct MusicControllerView: View {
		@State private var currentSong = Song()
		
		let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
		let configuration = Configuration.decoded
		var body: some View {
			VStack {
				Image(nsImage: currentSong.artwork)
					.resizable()
					.frame(width: 150, height: 150)
				Text(currentSong.name)
					.font(.title)
					.fontWeight(.semibold)
					.foregroundColor(configuration.textColor.color)
				Text(currentSong.artist + " - " + currentSong.album)
					.font(.title3)
					.foregroundColor(configuration.textColor.color)
				HStack {
					ApplicationButton(action: { currentSong.nextTrack() }) { Image(systemName: "backward") }
					ApplicationButton(action: { currentSong.playpause() }) { Image(systemName: "playpause") }
						.padding(2.5)
					ApplicationButton(action: { currentSong.previousTrack() }) { Image(systemName: "forward") }
				}
				Spacer()
			}
			.onReceive(timer) { _ in
				currentSong = Song()
			}
			
			Spacer()
		}
	}
	
	struct Song {
		var name: String
		var album: String
		var artist: String
		var artwork: NSImage
		
		init() {
			// Create a Scripting Bridge application.
			let app: AnyObject = SBApplication(bundleIdentifier: "com.apple.music")!
			
			// The currently playing track.
			let currentTrack = app.currentTrack()
			
			name = currentTrack.properties["name"] as? String ?? ""
			album = currentTrack.properties["album"] as? String ?? ""
			artist = currentTrack.properties["artist"] as? String ?? ""
			
			// Check if the track has artworks.
			guard let artworks = currentTrack.artworks else {
				artwork = NSImage()
				return
			}
			
			// Get the first artwork.
			let artwork = artworks[0] as AnyObject
			
			self.artwork = artwork.properties["data"] as? NSImage ?? NSImage()
		}
		
		func playpause() {
			AppleScript.executeByTellingSystemEvents(string: "tell application \"Music\" to playpause")
		}
		
		func nextTrack() {
			AppleScript.executeByTellingSystemEvents(string: "tell application \"Music\" to next track")
		}
		
		func previousTrack() {
			AppleScript.executeByTellingSystemEvents(string: "tell application \"Music\" to previous track")
		}
	}
}

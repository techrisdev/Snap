// ApplicationView.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

struct ApplicationView: View {
	var content: AnyView
	
	let configuration = Configuration.decoded
	var body: some View {
		ZStack {
			configuration.backgroundColor.color
			VStack {
				HStack {
					// A button for closing the application.
					ApplicationButton(action: {
						close()
					}) { Text("􀁡") }
					.padding()
					Spacer()
				}
				content
				Spacer()
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: .EscapeKeyWasPressed), perform: { _ in
			// When the escape key gets pressed, close the application.
			close()
		})
	}
	
	func close() {
		NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
	}
}

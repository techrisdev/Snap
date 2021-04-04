// ApplicationView.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

struct ApplicationView: View {
	var content: AnyView
	
	let configuration = Configuration.decoded
	var body: some View {
		ZStack {
			Color.fromHexString(configuration.backgroundColor)
			VStack {
				HStack {
					// A button for closing the application.
					ApplicationButton(action: {
						NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
					}) { Text("􀁡") }
					.padding()
					Spacer()
				}
				content
				Spacer()
			}
		}
	}
}

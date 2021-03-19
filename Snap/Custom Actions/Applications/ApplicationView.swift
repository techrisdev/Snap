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
					Button(action: {
						NotificationCenter.default.post(name: .ApplicationShouldExit, object: nil)
					}) {
						Text("􀁡")
							.foregroundColor(Color.fromHexString(configuration.textColor))
					}
					.padding()
					
					Spacer()
				}
				Spacer()
				content
			}
		}
	}
}

struct ApplicationView_Previews: PreviewProvider {
	static var previews: some View {
		ApplicationView(content: AnyView(Text("Hello, World")
											.foregroundColor(.white)))
	}
}

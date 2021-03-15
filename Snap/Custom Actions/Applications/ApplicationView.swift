// ApplicationView.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

struct ApplicationView: View {
	var content: AnyView
	var body: some View {
		ZStack {
			// MARK: TODO: Configured background color, not black.
			Color.black
			VStack {
				HStack {
					Button(action: {
						print("exit")
					}) {
						Image(systemName: "xmark.circle.fill")
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

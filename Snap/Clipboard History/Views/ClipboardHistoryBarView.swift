// ClipboardHistoryBarView.swift
//
// Created by TeChris on 12.04.21.

import SwiftUI

struct ClipboardHistoryBarView: View {
	let notificationCenter = NotificationCenter.default
	var body: some View {
		HStack {
			ApplicationButton(action: {
				notificationCenter.post(name: .ShouldDeleteClipboardHistoryItem, object: nil)
			}, frame: NSSize(width: 135, height: 25)) {
				Text("Delete Item")
			}
			Spacer()
			ApplicationButton(action: {
				notificationCenter.post(name: .ShouldDeleteClipboardHistory, object: nil)
			}, frame: NSSize(width: 135, height: 25)) {
				Text("Delete History")
			}
		}
		.padding(.trailing)
	}
}

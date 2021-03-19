// ApplicationSearchItem.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

protocol ApplicationSearchItem: SearchItem {
	/// The item's view.
	var view: ApplicationView { get }
}

extension ApplicationSearchItem {
	var view: ApplicationView {
		get {
			return ApplicationView(content: AnyView(Text("Generic Application.")))
		}
	}
}

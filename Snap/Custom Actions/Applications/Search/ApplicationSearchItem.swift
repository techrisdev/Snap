// ApplicationSearchItem.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

protocol ApplicationSearchItem: SearchItem {
	/// The item's view.
	var view: ApplicationView { get }
}

extension ApplicationSearchItem {
	var action: (String) -> Void {
		get {
			return { _ in }
		}
	}
}

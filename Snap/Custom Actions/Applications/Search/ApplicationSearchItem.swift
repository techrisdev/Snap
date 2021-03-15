// ApplicationSearchItem.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

class ApplicationSearchItem: SearchItem {
	/// The item's view.
	var view: ApplicationView {
		return ApplicationView(content: AnyView(Text("Generic Application.")))
	}
	
	init(name: String) {
		applicationName = name
		
		super.init(acceptsArguments: false)
	}
	
	private var applicationName: String
	
	override var name: String {
		return applicationName
	}
}

// ApplicationSearchItem.swift
//
// Created by TeChris on 14.03.21.

import SwiftUI

class ApplicationSearchItem: SearchItem {
	/// The item's view.
	var view: ApplicationView
	
	init(applicationView: ApplicationView, name: String) {
		view = applicationView
		applicationName = name
		
		super.init(acceptsArguments: false)
	}
	
	private var applicationName: String
	
	override var name: String {
		return applicationName
	}
}

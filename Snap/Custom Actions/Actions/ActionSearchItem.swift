// ActionSearchItem.swift
//
// Created by TeChris on 09.03.21.

import Cocoa

class ActionSearchItem: SearchItem {

	init(action: @escaping (String) -> Void, name: String, acceptsArguments: Bool = true) {
		self.temporaryName = name
		self.temporaryAction = action
		
		super.init(acceptsArguments: acceptsArguments)
	}
	
	private var temporaryName: String
	private var temporaryAction: (String) -> Void
	
	override var name: String {
		return self.temporaryName
	}
	
	override var icon: NSImage {
		let image = NSImage(named: name + "Icon") ?? NSImage()
		let configuration = Configuration.decoded
		image.size = NSSize(width: configuration.iconSizeWidth, height: configuration.iconSizeHeight)
		return image
	}

	override var action: (String) -> Void {
		return self.temporaryAction
	}
}

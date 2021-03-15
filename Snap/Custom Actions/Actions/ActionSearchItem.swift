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
	
	override var action: (String) -> Void {
		return self.temporaryAction
	}
	
	override var name: String {
		return self.temporaryName
	}
	
	override var icon: NSImage {
		let image = NSImage(named: name + "Icon")!
		image.size = Configuration.decoded.iconSize
		return image
	}
}

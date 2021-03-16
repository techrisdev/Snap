// SpotlightSearchItem.swift
//
// Created by TeChris on 09.03.21.

import Cocoa

class SpotlightSearchItem: SearchItem {
	
	private var item: NSMetadataItem
	
	init(item: NSMetadataItem) {
		self.item = item
		
		super.init(acceptsArguments: false)
	}
	
	/// The File System Size in Bytes.
	var size: Int? {
		return item.valueForAttribute(kMDItemFSSize, valueType: Int.self)
	}
	
	/// The path to the file.
	override var path: String {
		return item.valueForAttribute(kMDItemPath, valueType: String.self) ?? "/"
	}
	
	/// The Item's display name.
	override var name: String {
		return item.valueForAttribute(kMDItemDisplayName, valueType: String.self)!
	}
	
	/// The icon as an NSImage.
	override var icon: NSImage {
		let configuration = Configuration.decoded
		let iconSize = NSSize(width: configuration.iconSizeWidth, height: configuration.iconSizeHeight)
		let icon = NSWorkspace.shared.icon(forFile: path)
		icon.size = iconSize
		return icon
	}
	
	override var action: (String) -> Void {
		return { _ in
			NSWorkspace.shared.open(URL(fileURLWithPath: self.path))
		}
	}
}

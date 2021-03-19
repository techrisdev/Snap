// SpotlightSearchItem.swift
//
// Created by TeChris on 09.03.21.

import Cocoa

struct SpotlightSearchItem: SearchItem {
	private var item: NSMetadataItem
	
	init(item: NSMetadataItem) {
		self.item = item
	}
	
	var id = UUID()
	
	var acceptsArguments = false
	
	/// The File System Size in Bytes.
	var size: Int? {
		return item.valueForAttribute(kMDItemFSSize, valueType: Int.self)
	}
	
	/// The path to the file.
	var path: String {
		return item.valueForAttribute(kMDItemPath, valueType: String.self) ?? "/"
	}
	
	/// The Item's display name.
	var name: String {
		return item.valueForAttribute(kMDItemDisplayName, valueType: String.self)!
	}
	
	/// The icon as an NSImage.
	var icon: Icon {
		let configuration = Configuration.decoded
		let iconSize = NSSize(width: configuration.iconSizeWidth, height: configuration.iconSizeHeight)
		let nsImage = NSWorkspace.shared.icon(forFile: path)
		nsImage.size = iconSize
		
		let icon = Icon(image: nsImage)
		return icon
	}
	
	var action: (String) -> Void {
		return { _ in
			NSWorkspace.shared.open(URL(fileURLWithPath: self.path))
		}
	}
}

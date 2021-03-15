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
	
	/// The Item's Kind.
	override var kind: String? {
		return item.valueForAttribute(kMDItemKind, valueType: String.self)
	}
	
	/// The date when the Item was added.
	var dateAdded: Date?
	
	/// The Architectures of the executable.
	var executableArchitectures: [String]?
	
	/// The Item's last modification date.
	var modificationDate: Date?
	
	/// The Bundle ID.
	var bundleIdentifier: String?
	
	/// The version number of the Item.
	var version: Float?
	
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
		let iconSize = Configuration.decoded.iconSize
		let icon = NSWorkspace.shared.icon(forFile: path)
		icon.size = iconSize
		return icon
	}
	
	override var action: (String) -> Void {
		return { _ in
			NSWorkspace.shared.open(URL(fileURLWithPath: self.path))
		}
	}
	
	/// The date when the Item was last used.
	var lastUsedDate: Date? {
		return item.valueForAttribute(kMDItemLastUsedDate, valueType: Date.self)
	}

	/// The Item's name on the File System.
	var fileSystemName: String = ""
	
	/// Indicates invisibility on the FIle System.
	var isInvisible: Bool = false
}

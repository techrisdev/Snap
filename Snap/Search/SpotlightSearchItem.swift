// SpotlightSearchItem.swift
//
// Created by TeChris on 09.03.21.

import AppKit.NSWorkspace

// MARK: EDIT: It seems like the bug doesn't appear anymore. | TODO: The app crashes if the item is displayed but deleted.
struct SpotlightSearchItem: SearchItem {
	private var item: NSMetadataItem
	
	init(_ item: NSMetadataItem) {
		self.item = item
	}
	
	let id = UUID()
	
	var acceptsArguments = false
	
	/// The path to the file.
	var path: String {
		return item.valueForAttribute(kMDItemPath, valueType: String.self) ?? "/"
	}
	
	/// The Item's display name.
	var title: String {
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
			let url = URL(fileURLWithPath: path)
			NSWorkspace.shared.open(url)
		}
	}
}

// NSMetadataItem Extension.swift
//
// Created by TeChris on 08.03.21.

import Cocoa

extension NSMetadataItem {
	// This function makes the code look cleaner, if you already know the type of the value.
	/// Get the value for a specific attribute.
	public func valueForAttribute<T>(_ attribute: CFString, valueType: T.Type) -> T? {
		return self.value(forAttribute: attribute as String) as? T
	}
//	
//	var id: String {
//		return self.valueForAttribute(kMDItemPath , valueType: String.self)!
//	}
//	
//	var type: String? {
//		return self.valueForAttribute(kMDItemContentType, valueType: String.self)
//	}
//	
//	var displayName: String {
//		return self.valueForAttribute(kMDItemDisplayName, valueType: String.self)!
//	}
//	
//	var path: String? {
//		return self.valueForAttribute(kMDItemPath, valueType: String.self)
//	}
//	
//	var icon: NSImage {
//		if path == nil {
//			return NSImage()
//		}
//		
//		return NSWorkspace.shared.icon(forFile: path!)
//	}
}

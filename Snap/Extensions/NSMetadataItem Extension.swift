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
}

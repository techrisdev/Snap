// ActionSearchItem.swift
//
// Created by TeChris on 09.03.21.

import Cocoa

struct ActionSearchItem: SearchItem {
	var id = UUID()
	
	var name: String
	
	var acceptsArguments = true
	
	var action: (String) -> Void
}

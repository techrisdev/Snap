// String Extension.swift
//
// Created by TeChris on 09.03.21.

import Foundation

extension String {
	// This lets you subscript a String.
	subscript(idx: Int) -> String {
		String(self[index(startIndex, offsetBy: idx)])
	}
	
	public func firstCharacterCapitalized() -> String {
		let capitalizedFirstCharacter = self.first!.uppercased()
		let stringWithoutFirstCharacter = self.dropFirst()
		
		return capitalizedFirstCharacter + stringWithoutFirstCharacter
	}
}

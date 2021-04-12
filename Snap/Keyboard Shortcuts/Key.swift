// Key.swift
//
// Created by TeChris on 10.04.21.

import Carbon

struct Key: Codable {
	var keyCode: UInt32
	
	// Reference: https://stackoverflow.com/a/35138823 https://gist.github.com/ArthurYidi/3af4ccd7edc87739530476fc80a22e12
	/// Convert the key cdoe to a character.
	var character: Character {
		let keyboard = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
		guard let layoutPointer = TISGetInputSourceProperty(keyboard, kTISPropertyUnicodeKeyLayoutData) else { fatalError("Failed to get layout data.") }
		let layoutData = Unmanaged<CFData>.fromOpaque(layoutPointer).takeUnretainedValue() as Data
		var deadKeyState: UInt32 = 0
		var stringLength = 0
		var unicodeString = [UniChar](repeating: 0, count: 255)
		let status = layoutData.withUnsafeBytes {
			UCKeyTranslate($0.bindMemory(to: UCKeyboardLayout.self).baseAddress,
						   UInt16(keyCode),
						   UInt16(kUCKeyActionDown),
						   0,
						   UInt32(LMGetKbdType()),
						   0,
						   &deadKeyState,
						   255,
						   &stringLength,
						   &unicodeString)
		}
		
		if status != noErr {
			fatalError("Translation process failed.")
		}
		
		let string = NSString(characters: unicodeString, length: stringLength) as String
		let character = [Character](string)[0]
		
		return character
	}
}

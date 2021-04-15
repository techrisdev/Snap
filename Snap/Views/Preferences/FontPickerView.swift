// FontPickerView.swift
//
// Created by TeChris on 02.04.21.

import SwiftUI

struct FontPickerView: View {
	@Binding var font: Font
	@State private var fontPicker: FontPicker!
	var body: some View {
		HStack {
			Text("Font: \(font.name) \(font.size, specifier: "%g")")
			Button("Choose Font") {
				fontPicker = FontPicker(font: $font)
				fontPicker.open()
			}
		}
	}
}

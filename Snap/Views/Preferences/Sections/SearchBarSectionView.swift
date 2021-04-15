// SearchBarSectionView.swift
//
// Created by TeChris on 15.04.21.

import SwiftUI

struct SearchBarSectionView: View {
	@Binding var searchBarFont: Font
	@Binding var searchBarHeight: CGFloat
	@Binding var insertionPointColor: Color
    var body: some View {
		PreferencesSection(text: "Search Bar") {
			FontPickerView(font: $searchBarFont)
			Stepper("Height: \(searchBarHeight, specifier: "%g")", value: $searchBarHeight)
			ColorPicker("Insertion Point Color", selection: $insertionPointColor)
		}
    }
}

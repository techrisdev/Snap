// VerticallyCenteredTextFieldCell.swift
//
// Created by TeChris on 03.04.21.

import AppKit

// Reference: https://stackoverflow.com/a/45995951/14456607
/// A custom NSTextField cell which centers text vertically.
class VerticallyCenteredTextFieldCell: NSTextFieldCell {
	func adjustedFrame(in rect: NSRect) -> NSRect {
		// super would normally draw text at the top of the cell
		var titleRect = super.titleRect(forBounds: rect)

		let minimumHeight = self.cellSize(forBounds: rect).height
		titleRect.origin.y += (titleRect.height - minimumHeight) / 2
		titleRect.size.height = minimumHeight

		return titleRect
	}

	// Center the text when the cell is being edited.
	override func edit(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, event: NSEvent?) {
		super.edit(withFrame: adjustedFrame(in: rect), in: controlView, editor: textObj, delegate: delegate, event: event)
	}
	
	// Center the text when the cell is selected.
	override func select(withFrame rect: NSRect, in controlView: NSView, editor textObj: NSText, delegate: Any?, start selStart: Int, length selLength: Int) {
		super.select(withFrame: adjustedFrame(in: rect), in: controlView, editor: textObj, delegate: delegate, start: selStart, length: selLength)
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		super.drawInterior(withFrame: adjustedFrame(in: cellFrame), in: controlView)
	}

	override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
		super.draw(withFrame: cellFrame, in: controlView)
	}
}

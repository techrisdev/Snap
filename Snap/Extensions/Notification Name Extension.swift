// Notification Name Extension.swift
//
// Created by TeChris on 08.03.21.

import Foundation

extension Notification.Name {
	static let ReturnKeyWasPressed = Notification.Name("ReturnKeyWasPressed")
	static let UpArrowKeyWasPressed = Notification.Name("UpArrowKeyWasPressed")
	static let DownArrowKeyWasPressed = Notification.Name("DownArrowKeyWasPressed")
	static let TabKeyWasPressed = Notification.Name("TabKeyWasPressed")
	static let EscapeKeyWasPressed = Notification.Name("EscapeKeyWasPressed")
	static let CommandKeyWasPressed = Notification.Name("CommandKeyWasPressed")
	static let ApplicationShouldExit = Notification.Name("ApplicationShouldExit")
	static let ShouldPresentQuickLook = Notification.Name("ShouldPresentQuickLook")
	static let ShouldDeleteClipboardHistoryItem = Notification.Name("ShouldDeleteClipboardHistoryItem")
	static let ShouldDeleteClipboardHistory = Notification.Name("ShouldDeleteClipboardHistory")
}

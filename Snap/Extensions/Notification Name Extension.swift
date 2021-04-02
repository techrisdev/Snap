// Notification Name Extension.swift
//
// Created by TeChris on 08.03.21.

import Foundation

extension Notification.Name {
	static let TextChanged = Notification.Name("TextChanged")
	static let ReturnKeyWasPressed = NSNotification.Name("ReturnKeyWasPressed")
	static let UpArrowKeyWasPressed = NSNotification.Name("UpArrowKeyWasPressed")
	static let DownArrowKeyWasPressed = NSNotification.Name("DownArrowKeyWasPressed")
	static let TabKeyWasPressed = NSNotification.Name("TabKeyWasPressed")
	static let CommandKeyPressed = NSNotification.Name("CommandKeyPressed")
	static let CommandKeyReleased = NSNotification.Name("CommandKeyReleased")
	static let ApplicationShouldExit = NSNotification.Name("ApplicationShouldExit")
	static let ShouldPresentQuickLook = NSNotification.Name("ShouldPresentQuickLook")
}

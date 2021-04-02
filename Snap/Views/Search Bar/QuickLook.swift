// QuickLook.swift
//
// Created by TeChris on 21.03.21.

import Quartz

class QuickLook: NSObject, QLPreviewPanelDataSource {
	/// The path to the presented file.
	var filePath: String?
	
	// The preview panel.
	private var panel = QLPreviewPanel.shared()
	
	/// Initialize the class with an optional URL.
	init(filePath: String? = nil) {
		self.filePath = filePath
	}
	
	/// This notification gets send when the preview panel will close.
	static let panelWillCloseNotification = NSNotification.Name("QuickLookPreviewPanelWillClose")
	
	/// Present a preview panel.
	func present() {
		panel?.updateController()
		panel?.dataSource = self
		panel?.makeKeyAndOrderFront(self)
		
		// Start listening for notifications.
		startObserving()
	}

	/// The default notification center.
	private let notificationCenter = NotificationCenter.default
	
	/// Start observing preview panel notifications.
	private func startObserving() {
		// Listen for the "willClose" notification.
		notificationCenter.addObserver(self, selector: #selector(panelWillClose), name: QLPreviewPanel.willCloseNotification, object: nil)
	}
	
	@objc private func panelWillClose() {
		print(QLPreviewPanel.willCloseNotification)
		notificationCenter.post(name: QuickLook.panelWillCloseNotification, object: nil)
	}
	
	func stopObserving() {
		// Remove the observer.
		notificationCenter.removeObserver(self)
	}
	
	func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
		// The panel contains 1 item.
		return 1
	}
	
	func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
		// Unwrap the file path.
		guard let filePath = filePath else { return nil }
		
		// Present the file at the specified path.
		return NSURL(fileURLWithPath: filePath)
	}
}

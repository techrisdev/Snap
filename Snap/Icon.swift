// Icon.swift
//
// Created by TeChris on 19.03.21.

import AppKit.NSImage

struct Icon: Codable {
	/// The path to the image.
	var path: String? = nil
	
	private var nsImage: NSImage? = nil
	
	/// Initialize with a NSImage.
	init(_ nsImage: NSImage) {
		self.nsImage = nsImage
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		path = try container.decodeIfPresent(String.self, forKey: .path)
	}
	
	init(path: String? = nil, image: NSImage? = nil) {
		self.path = path
		nsImage = image
	}
	
	enum CodingKeys: CodingKey {
		case path
	}
	
	var image: NSImage {
		// If there is an provided image, then return it.
		if nsImage != nil {
			return nsImage!
		}
		
		if path != nil {
			// Get an image from the specified path.
			if let image = NSImage(contentsOf: URL(fileURLWithPath: path!)) {
				// Configure the image.
				let configuration = Configuration.decoded
				image.size = NSSize(width: configuration.iconSizeWidth, height: configuration.iconSizeHeight)
				
				// Return the new image.
				return image
			}
		}
		
		// If the image doesn't exist, or no path was provided, return an empty image.
		return NSImage()
	}
}

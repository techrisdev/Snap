// CalculatorSearchItem.swift
//
// Created by TeChris on 16.04.21.

import Foundation
import AppKit.NSWorkspace

struct CalculatorSearchItem: SearchItem {
	let id = UUID()
	
	var name: String {
		var name = calculation
		
		let result = calculate()
		if result != "" {
			name.append(" = " + result)
		}
		
		return name
	}
	
	var calculation: String
	
	let icon = Icon(NSWorkspace.shared.icon(forFile: "/System/Applications/Calculator.app"))
	
	let acceptsArguments = false
	
	// Copy the result to the clipboard.
	var action: (String) -> Void {
		return { _ in
			let pasteboard = NSPasteboard.general
			pasteboard.declareTypes([.string], owner: nil)
			pasteboard.setString(calculate(), forType: .string)
		}
	}
	
	private func calculate() -> String {
		// Calculate with python.
		let process = Process()
		let pipe = Pipe()
		
		// The preinstalled version of python. It's old, but it gets the job done.
		process.launchPath = "/System/Library/Frameworks/Python.framework/Versions/Current/bin/python"
		
		// Configure the process.
		process.arguments = ["-c", "print(\(calculation))"]
		process.standardOutput = pipe
		process.launch()
		
		// Get the output from the process.
		let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
		let outputString = String(data: outputData, encoding: .utf8)
		
		return outputString!.replacingOccurrences(of: "\n", with: "")
	}
}

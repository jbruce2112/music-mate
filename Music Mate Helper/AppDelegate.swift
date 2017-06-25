//
//  AppDelegate.swift
//  Music Mate Helper
//
//  Created by John on 6/25/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// This helper app is located at <MainBundleRoot>/Contents/Library/LoginItems/<HelperBundle>
		// We can get the main bundle path by removing the last four path components
		var helperPath = Bundle.main.bundlePath.components(separatedBy: "/")
		
		for _ in 0..<4 {
			helperPath.remove(at: helperPath.count - 1)
		}
		
		let mainAppPath = NSString.path(withComponents: helperPath)
		NSWorkspace.shared().launchApplication(mainAppPath)
		
		NSApp.terminate(self)
	}
}

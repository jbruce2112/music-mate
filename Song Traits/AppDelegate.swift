//
//  AppDelegate.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	private let api = SpotifyAPI()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		api.auth {
			
			guard let vc = NSApplication.shared().windows.first?.contentViewController as? MainViewController else {
				return
			}
			
			vc.api = self.api
			self.api.currentPlayback { string in
				
				if let str = string {
					print(str)
				}
			}
		}
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}


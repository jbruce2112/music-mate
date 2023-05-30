//
//  PrefViewController.swift
//  Music Mate
//
//  Created by John on 6/25/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa
import ServiceManagement

class PrefViewController: NSViewController {
	
	@IBOutlet private var loginButton: NSButton!
	
	private let defaults = UserDefaults()
	private let StartAtLoginKey = "StartAtLogin"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        loginButton.state = defaults.bool(forKey: StartAtLoginKey) ? NSControl.StateValue.on : NSControl.StateValue.off
	}
	
	@IBAction func startOnLoginPressed(sender: NSButton) {
	
		let helperID = "com.bruce32.MusicMateHelper"
		let enabled = sender.state == NSControl.StateValue.on
		
		if SMLoginItemSetEnabled(helperID as CFString, enabled) {
			defaults.set(enabled, forKey: StartAtLoginKey)
		} else {
			NSLog("Failed to add login item.")
		}
	}
}

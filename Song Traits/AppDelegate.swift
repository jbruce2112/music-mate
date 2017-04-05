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

	private var mainViewController: MainViewController!
	private let api = SpotifyAPI()
	private let statusItem: NSStatusItem = {
		
		let item = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
		item.image = #imageLiteral(resourceName: "MenuIcon")
		item.image?.isTemplate = true
		
		let menu = NSMenu()
		let infoItem = NSMenuItem()
		infoItem.title = "Current Song Info"
		infoItem.target = self as AnyObject
		infoItem.action = #selector(showWindow)
		menu.addItem(infoItem)
		
		item.menu = menu
		
		return item
	}()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		mainViewController = NSApplication.shared().windows[1].contentViewController as! MainViewController
		
		api.auth {
			
			self.mainViewController.api = self.api
		}
	}
	
	func showWindow() {
		
		NSApp.activate(ignoringOtherApps: true)
		mainViewController.refreshCurrentSong()
	}
}

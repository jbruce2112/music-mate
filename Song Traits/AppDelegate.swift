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
	
	private let api = SpotifyAPI()
	private var infoViewController: InfoViewController!
	private var traitsViewController: TraitsViewController!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		let tabViewController = NSApplication.shared().windows[1].contentViewController as! NSTabViewController
		traitsViewController = tabViewController.tabViewItems[0].viewController as! TraitsViewController
		infoViewController = tabViewController.tabViewItems[1].viewController as! InfoViewController
		
		api.auth {
			
			self.traitsViewController.api = self.api
			self.infoViewController.api = self.api
		}
	}
	
	func showWindow() {
		
		NSApp.activate(ignoringOtherApps: true)
		traitsViewController.refreshCurrentSong()
		infoViewController.refreshCurrentSong()
	}
}

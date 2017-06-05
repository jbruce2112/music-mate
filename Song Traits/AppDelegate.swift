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
	private var window: NSWindow!
	private var infoViewController: InfoViewController!
	private var traitsViewController: TraitsViewController!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		window = NSApplication.shared().windows[1]
		
		let tabViewController = window.contentViewController as! NSTabViewController
		traitsViewController = tabViewController.tabViewItems[0].viewController as! TraitsViewController
		infoViewController = tabViewController.tabViewItems[1].viewController as! InfoViewController
		
		api.auth {
			
			self.traitsViewController.api = self.api
			self.infoViewController.api = self.api
		}
		
		window.isReleasedWhenClosed = false
		
		// Initially hide main window
		hideWindow()
	}
	
	@objc
	private func showWindow() {
		
		window.makeKeyAndOrderFront(self)
		NSApp.activate(ignoringOtherApps: true)
		
		traitsViewController.refreshCurrentSong()
		infoViewController.refreshCurrentSong()
	}
	
	private func hideWindow() {
		
		window.orderOut(self)
	}
}

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
	
	private var api: SpotifyAPI?
	private var window: NSWindow!
	
	fileprivate var infoViewController: InfoViewController!
	fileprivate var traitsViewController: TraitsViewController!
	
	fileprivate var menuBarManager = MenuBarManager()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		window = NSApp.windows[1]
		
		let tabViewController = window.contentViewController as! NSTabViewController
		traitsViewController = tabViewController.tabViewItems[0].viewController as! TraitsViewController
		infoViewController = tabViewController.tabViewItems[1].viewController as! InfoViewController
		
		api = SpotifyAPI(self)
		
		api?.auth {
			
			self.traitsViewController.api = self.api
			self.infoViewController.api = self.api
			self.menuBarManager.api = self.api
			
			// Fetch initial data
			self.refresh()
		}
		
		window.isReleasedWhenClosed = false
		
		// Initially hide main window
		window.orderOut(self)
	}
	
	func showWindow() {
		
		window.makeKeyAndOrderFront(self)
		NSApp.activate(ignoringOtherApps: true)
		
		refresh()
	}
	
	func refresh() {
		
		api?.currentSong(completion: nil)
	}
}

extension AppDelegate: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
		
		menuBarManager.songDidChange(song)
		traitsViewController.songDidChange(song)
		infoViewController.songDidChange(song)
	}
}

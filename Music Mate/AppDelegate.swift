//
//  AppDelegate.swift
//  Music Mate
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	private var api: SpotifyAPI?
	private var window: NSWindow!
	
	private let infoTabIndex = 0
	private let featuresTabIndex = 1
	private let prefTabIndex = 2
	
	private var tabViewController: NSTabViewController!
	
	fileprivate var infoViewController: InfoViewController!
	fileprivate var featuresViewController: FeaturesViewController!
	private var prefViewController: PrefViewController!
	
	fileprivate var menuBarManager = MenuBarManager()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		window = NSApp.windows[1]
		
		tabViewController = window.contentViewController as! NSTabViewController
		infoViewController = tabViewController.tabViewItems[infoTabIndex].viewController as! InfoViewController
		featuresViewController = tabViewController.tabViewItems[featuresTabIndex].viewController as! FeaturesViewController
		prefViewController = tabViewController.tabViewItems[prefTabIndex].viewController as! PrefViewController
		
		api = SpotifyAPI(self)
		
		api?.auth {
			
			self.featuresViewController.api = self.api
			self.infoViewController.api = self.api
			self.menuBarManager.api = self.api
			
			// Fetch initial data
			self.refresh()
		}
		
		window.isReleasedWhenClosed = false
		
		// Initially hide window
		window.orderOut(self)
	}
	
	func showInfoWindow() {
		
		showWindow()
		tabViewController.selectedTabViewItemIndex = infoTabIndex
		
		refresh()
	}
	
	func showPrefWindow() {
		
		showWindow()
		tabViewController.selectedTabViewItemIndex = prefTabIndex
	}
	
	func refresh() {
		
		api?.currentSong(completion: nil)
	}
	
	private func showWindow() {
		
		window.makeKeyAndOrderFront(self)
		NSApp.activate(ignoringOtherApps: true)
	}
	
}

extension AppDelegate: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
		
		menuBarManager.songDidChange(song)
		featuresViewController.songDidChange(song)
		infoViewController.songDidChange(song)
	}
}

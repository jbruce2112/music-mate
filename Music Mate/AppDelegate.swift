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
	
	private var api: SpotifyAPI!
	private var window: NSWindow!
	
	private let infoTabIndex = 0
	private let featuresTabIndex = 1
	private let prefTabIndex = 2
	
	private var tabViewController: NSTabViewController!
	
	private var infoViewController: InfoViewController!
    private var featuresViewController: FeaturesViewController!
    private var prefViewController: PrefViewController!
	
    private var menuBarManager: MenuBarManager!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// Render the menu right away
		menuBarManager = MenuBarManager()
		
		api = SpotifyAPI(self)
		
		window = NSApp.windows[0]
		
        tabViewController = window.contentViewController as? NSTabViewController
        infoViewController = tabViewController.tabViewItems[infoTabIndex].viewController as? InfoViewController
        featuresViewController = tabViewController.tabViewItems[featuresTabIndex].viewController as? FeaturesViewController
        prefViewController = tabViewController.tabViewItems[prefTabIndex].viewController as? PrefViewController
		
		api.auth {
			
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
	
	// MARK: Window display functions
	func showInfoWindow() {
		
		// Make sure we have the latest song
		refresh()
		
		showWindow()
		tabViewController.selectedTabViewItemIndex = infoTabIndex
	}
	
	func showPrefWindow() {
		
		showWindow()
		tabViewController.selectedTabViewItemIndex = prefTabIndex
	}
	
	private func refresh() {
		
		api.refreshCurrentSong()
	}
	
	private func showWindow() {
		
		window.makeKeyAndOrderFront(self)
		NSApp.activate(ignoringOtherApps: true)
	}
	
}

// MARK: SongChangeDelegate conformance
extension AppDelegate: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
		
		menuBarManager.songDidChange(song)
		featuresViewController.songDidChange(song)
		infoViewController.songDidChange(song)
	}
}

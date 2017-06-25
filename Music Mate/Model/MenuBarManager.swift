//
//  MenuBarManager.swift
//  Music Mate
//
//  Created by John on 6/25/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class MenuBarManager {
	
	var api: SpotifyAPI?
	
	fileprivate let statusItem: NSStatusItem
	
	init() {
		
		statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
		statusItem.image = #imageLiteral(resourceName: "MenuIcon")
		statusItem.image?.isTemplate = true
		
		let basicMenu = NSMenu()
		
		for item in headerItems() {
			basicMenu.addItem(item)
		}
		
		basicMenu.addItem(NSMenuItem.separator())
		
		for item in footerItems() {
			basicMenu.addItem(item)
		}
		
		statusItem.menu = basicMenu
	}
	
	fileprivate func headerItems() -> [NSMenuItem] {
		
		var items = [NSMenuItem]()
				
		let showWindowItem = NSMenuItem(title: "Show", action: #selector(show), keyEquivalent: "")
		showWindowItem.target = self
		items.append(showWindowItem)
		
		let refreshItem = NSMenuItem(title: "Refresh", action: #selector(refresh), keyEquivalent: "r")
		refreshItem.target = self
		items.append(refreshItem)
		
		return items
	}
	
	fileprivate func footerItems() -> [NSMenuItem] {
		
		var items = [NSMenuItem]()
		
		let prefItem = NSMenuItem(title: "Preferences", action: #selector(showPref), keyEquivalent: ",")
		prefItem.target = self
		items.append(prefItem)
		
		items.append(NSMenuItem.separator())
		
		let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q")
		quitItem.target = self
		items.append(quitItem)
		
		return items
	}
	
	@objc
	private func refresh() {
		
		guard let delegate = NSApp.delegate as? AppDelegate else {
			return
		}
		
		delegate.refresh()
	}
	
	@objc
	private func show() {
		
		guard let delegate = NSApp.delegate as? AppDelegate else {
			return
		}
		
		delegate.showInfoWindow()
	}
	
	@objc
	private func showPref() {
		
		guard let delegate = NSApp.delegate as? AppDelegate else {
			return
		}
		
		delegate.showPrefWindow()
	}
	
	@objc
	private func quit() {
		
		NSApp.terminate(self)
	}
}

extension MenuBarManager: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
	
		let newMenu = NSMenu()
		
		for item in headerItems() {
			newMenu.addItem(item)
		}
		
		newMenu.addItem(NSMenuItem.separator())
		
		newMenu.addItem(withTitle: song.name, action: nil, keyEquivalent: "")
		newMenu.addItem(withTitle: song.artists.first?.name ?? "", action: nil, keyEquivalent: "")
		newMenu.addItem(withTitle: song.album.name, action: nil, keyEquivalent: "")
		
		let featuresMenu = NSMenu()
		
		let featuresMenuItem = NSMenuItem(title: "Features", action: nil, keyEquivalent: "")
		featuresMenuItem.submenu = featuresMenu
		
		newMenu.addItem(featuresMenuItem)
		
		// Populate the submenu once we get the features
		api?.features(forSong: song) { features in
			
			guard let features = features else {
				return
			}
			
			for (name, value) in features.formattedValues() {
				featuresMenu.addItem(withTitle: "\(name) : \(value)", action: nil, keyEquivalent: "")
			}
		}
		
		newMenu.addItem(NSMenuItem.separator())
		
		for item in footerItems() {
			newMenu.addItem(item)
		}
		
		statusItem.menu = newMenu
	}
}

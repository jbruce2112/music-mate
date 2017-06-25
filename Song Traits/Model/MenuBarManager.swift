//
//  MenuBarManager.swift
//  Song Traits
//
//  Created by John on 6/25/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class MenuBarManager {
	
	var api: SpotifyAPI?
	var features: Features?
	
	fileprivate let statusItem: NSStatusItem
	
	init() {
		
		statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
		statusItem.image = #imageLiteral(resourceName: "MenuIcon")
		statusItem.image?.isTemplate = true
		
		let basicMenu = NSMenu()
		
		for item in headerItems() {
			basicMenu.addItem(item)
		}
		
		for item in footerItems() {
			basicMenu.addItem(item)
		}
		
		statusItem.menu = basicMenu
	}
	
	fileprivate func headerItems() -> [NSMenuItem] {
		
		var items = [NSMenuItem]()
		
		let refreshItem = NSMenuItem(title: "Refresh", action: #selector(refresh), keyEquivalent: "")
		refreshItem.target = self
		items.append(refreshItem)
		
		let showWindowItem = NSMenuItem(title: "Show Window", action: #selector(showWindow), keyEquivalent: "")
		showWindowItem.target = self
		items.append(showWindowItem)
		
		return items
	}
	
	fileprivate func footerItems() -> [NSMenuItem] {
		
		let quitItem = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
		quitItem.target = self
		
		return [quitItem]
	}
	
	@objc
	fileprivate func refresh() {
		
		guard let delegate = NSApp.delegate as? AppDelegate else {
			return
		}
		
		delegate.refresh()
	}
	
	@objc
	fileprivate func showWindow() {
		
		guard let delegate = NSApp.delegate as? AppDelegate else {
			return
		}
		
		delegate.showWindow()
	}
	
	@objc
	fileprivate func quit() {
		
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
		
		newMenu.addItem(NSMenuItem.separator())
		
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
		
		for item in footerItems() {
			newMenu.addItem(item)
		}
		
		statusItem.menu = newMenu
	}
}

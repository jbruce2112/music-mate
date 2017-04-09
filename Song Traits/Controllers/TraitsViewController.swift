//
//  TraitsViewController.swift
//  Song Traits
//
//  Created by John on 4/9/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class TraitsViewController: NSViewController {
	
	var api: SpotifyAPI? {
		didSet {
			refreshCurrentSong()
		}
	}
	
	
	@IBOutlet var traitsLabel: NSTextField!
	private var currentSong: Song?
	
	@IBAction func refresh(_ sender: AnyObject) {
		
		refreshCurrentSong()
	}
	
	func refreshCurrentSong() {
		
		api?.currentSong { song in
			
			guard let song = song else {
				return
			}
			
			self.currentSong = song
			self.showTraits(for: song)
		}
	}
	
	private func showTraits(for song: Song) {
		
		api?.features(forSong: song) { features in
			
			guard let features = features else {
				return
			}
			
			self.traitsLabel.stringValue = features.formattedString()
		}
	}
}

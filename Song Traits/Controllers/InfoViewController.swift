//
//  InfoViewController.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {

	var api: SpotifyAPI? {
		didSet {
			refreshCurrentSong()
		}
	}
	
	private var currentSong: Song?
	
	@IBOutlet private var nameLabel: NSTextField!
	@IBOutlet private var artistLabel: NSTextField!
	@IBOutlet private var albumLabel: NSTextField!
	@IBOutlet private var albumView: NSImageView!

	@IBAction func refresh(_ sender: AnyObject) {
		
		refreshCurrentSong()
	}
	
	func refreshCurrentSong() {
		
		api?.currentSong { song in
			
			guard let song = song else {
				return
			}
			
			self.currentSong = song
			
			self.nameLabel.stringValue = song.name
			self.albumLabel.stringValue = song.album.name
			
			if let artist = song.artists.first {
				self.artistLabel.stringValue = artist.name
			}
			
			self.api?.image(for: song.album.imageURL) { image in
				
				guard
					let imageData = image,
					let image = NSImage(data: imageData) else {
						return
				}
				
				self.albumView.image = image
			}
		}
	}

}

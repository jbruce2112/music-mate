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
	private let progressIndicator = NSProgressIndicator()
	
	@IBOutlet private var nameLabel: NSTextField!
	@IBOutlet private var artistLabel: NSTextField!
	@IBOutlet private var albumLabel: NSTextField!
	@IBOutlet private var albumView: NSImageView!

	@IBAction func refresh(_ sender: AnyObject) {
		
		refreshCurrentSong()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		progressIndicator.isDisplayedWhenStopped = false
		progressIndicator.style = .spinningStyle
		albumView.addSubview(progressIndicator)
	}
	
	override func viewWillAppear() {
		super.viewWillAppear()
		
		progressIndicator.frame = albumView.bounds
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
			
			// Replace image with an empty clear image of
			// the same size to avoid resizing while loading the new one
			if let image = self.albumView.image {
				let clearImage = NSImage(size: image.size)
				clearImage.backgroundColor = .clear
				self.albumView.image = clearImage
			}
			
			self.progressIndicator.startAnimation(self)
			
			self.api?.image(for: song.album.imageURL) { image in
				sleep(3)
				DispatchQueue.main.async {
					
					self.progressIndicator.stopAnimation(self)
					
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

}

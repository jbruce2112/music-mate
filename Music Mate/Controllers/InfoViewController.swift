//
//  InfoViewController.swift
//  Music Mate
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class InfoViewController: NSViewController {

	weak var api: SpotifyAPI?
	
	fileprivate let progressIndicator = NSProgressIndicator()
	
	@IBOutlet fileprivate var nameLabel: NSTextField!
	@IBOutlet fileprivate var artistLabel: NSTextField!
	@IBOutlet fileprivate var albumLabel: NSTextField!
	@IBOutlet fileprivate var albumView: NSImageView!
	
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
}

/// MARK: SongChangeDelegate
extension InfoViewController: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
		
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

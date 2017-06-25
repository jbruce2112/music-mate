//
//  Album.swift
//  Music Mate
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation

struct Album {
	
	let id: String
	let name: String
	let artists: [Artist]
	let imageURL: URL
	
	init?(fromJSON json: [String: Any]) {
		
		guard
			let id = json["id"] as? String,
			let type = json["type"] as? String,
			let name = json["name"] as? String,
			let images = json["images"] as? [[String: Any]],
			let url = images.first?["url"] as? String,
			let imageURL = URL(string: url),
			let artistsJSON = json["artists"] as? [[String: Any]],
			type == "album" else {
				return nil
		}
		
		self.id = id
		self.name = name
		self.artists = Artist.createArray(fromJSONArray: artistsJSON)
		
		// TODO: check the widths and try and
		// get the closest one to the size we need
		self.imageURL = imageURL
	}
}

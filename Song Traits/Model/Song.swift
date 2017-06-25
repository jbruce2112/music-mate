//
//  Song.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

struct Song {
	
	let id: String
	let name: String
	let album: Album
	let artists: [Artist]
	
	init?(fromJSON json: [String: Any]) {
		
		guard
			let id = json["id"] as? String,
			let type = json["type"] as? String,
			let albumJSON = json["album"] as? [String: Any],
			let album = Album(fromJSON: albumJSON),
			let artistsJSON = json["artists"] as? [[String: Any]],
			let name = json["name"] as? String,
			type == "track" else {
			return nil
		}
		
		self.id = id
		self.name = name
		self.album = album
		self.artists = Artist.createArray(fromJSONArray: artistsJSON)
	}
}

extension Song: Equatable {
	
	static func == (lhs: Song, rhs: Song) -> Bool {
		return lhs.id == rhs.id
	}
}

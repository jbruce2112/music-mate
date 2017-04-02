//
//  Artist.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

struct Artist {
	
	let id: String
	let name: String
	
	init?(fromJSON json: [String: Any]) {
		
		guard
			let id = json["id"] as? String,
			let type = json["type"] as? String,
			let name = json["name"] as? String,
			type == "artist" else {
				return nil
		}
		
		self.id = id
		self.name = name
	}
	
	static func createArray(fromJSONArray artistArray: [[String: Any]]) -> [Artist] {
		
		var artists = [Artist]()
		for artistJSON in artistArray {
			
			guard let artist = Artist(fromJSON: artistJSON) else {
				continue
			}
			
			artists.append(artist)
		}
		
		return artists
	}
}

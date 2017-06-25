//
//  Features.swift
//  Music Mate
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation

enum Mode: Int {
	case Minor
	case Major
	case Unknown
}

enum Key: Int {
	case C
	case CSharp
	case D
	case DSharp
	case E
	case F
	case FSharp
	case G
	case GSharp
	case A
	case ASharp
	case B
	case Unknown
}

class Features {
	
	let acousticness: Float
	let danceability: Float
	let energy: Float
	let instrumentalness: Float
	let key: Key
	let liveness: Float
	let loudness: Float
	let mode: Mode
	let speechiness: Float
	let tempo: Float
	let timeSignature: Int
	let valence: Float
	
	init?(fromJSON json: [String: Any]) {
		
		guard
			let acousticness = json["acousticness"] as? Float,
			let danceability = json["danceability"] as? Float,
			let energy = json["energy"] as? Float,
			let instrumentalness = json["instrumentalness"] as? Float,
			let key = json["key"] as? Int,
			let liveness = json["liveness"] as? Float,
			let loudness = json["loudness"] as? Float,
			let mode = json["mode"] as? Int,
			let speechiness = json["speechiness"] as? Float,
			let tempo = json["tempo"] as? Float,
			let timeSignature = json["time_signature"] as? Int,
			let valence = json["valence"] as? Float,
			let type = json["type"] as? String,
			type == "audio_features" else {
				return nil
		}
		
		self.acousticness = acousticness
		self.danceability = danceability
		self.energy = energy
		self.instrumentalness = instrumentalness
		self.key = Key(rawValue: key) ?? .Unknown
		self.liveness = liveness
		self.loudness = loudness
		self.mode = Mode(rawValue: mode) ?? .Unknown
		self.speechiness = speechiness
		self.tempo = tempo
		self.timeSignature = timeSignature
		self.valence = valence
	}
	
	func formattedValues() -> [(String, String)] {
		
		var values = [(String, String)]()
		values.append(("Acousticness", formatPercent(acousticness)))
		values.append(("Danceability", formatPercent(danceability)))
		values.append(("Energy", formatPercent(energy)))
		values.append(("Intrumentalness", formatPercent(instrumentalness)))
		values.append(("Key", String(describing: key)))
		values.append(("Liveness", formatPercent(liveness)))
		values.append(("Loudness", "\(loudness) dB"))
		values.append(("Mode", String(describing: mode)))
		values.append(("Speechiness", formatPercent(speechiness)))
		values.append(("Tempo", "\(Int(tempo)) BPM"))
		values.append(("TimeSignature", String(describing: timeSignature)))
		values.append(("Valence", formatPercent(valence)))
		
		return values
	}
	
	private func formatPercent(_ value: Float) -> String {
		return "\(value * 100)%"
	}
}

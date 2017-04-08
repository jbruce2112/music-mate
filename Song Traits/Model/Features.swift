//
//  Features.swift
//  Song Traits
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
	
	func formattedString() -> String {
		
		return
			"acousticness: \(formatPercent(acousticness))\n" +
			"danceability: \(formatPercent(danceability))\n" +
			"energy: \(formatPercent(energy))\n" +
			"intrumentalness: \(formatPercent(instrumentalness))\n" +
			"key: \(key)\n" +
			"liveness: \(formatPercent(liveness))\n" +
			"loudness: \(loudness) dB\n" +
			"mode: \(mode)\n" +
			"speechiness: \(formatPercent(speechiness))\n" +
			"tempo: \(Int(tempo)) BPM\n" +
			"timeSignature: \(timeSignature)\n" +
			"valence: \(formatPercent(valence))\n"
	}
	
	private func formatPercent(_ value: Float) -> String {
		return "\(value * 100)%"
	}
}

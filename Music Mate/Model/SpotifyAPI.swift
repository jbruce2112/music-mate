//
//  SpotifyAPI.swift
//  Music Mate
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation

protocol SongChangeDelegate: class {
	func songDidChange(_ song: Song)
}

/// The SpotifyAPI class encapsulates all
/// network communication from the other components.
/// It maintains a login state, provides a number of
/// endpoint calls to get information about what music
/// is playing and what device it is playing on.
/// Users of this class can optionally instantiate it
/// with a delegate to be notified of song change events.
class SpotifyAPI {
	
	// MARK: Properties
	private let clientID: String
	
	private let apiBaseURL = URL(string: "https://api.spotify.com")!
	
	private var authState: AuthState?
	private let authenticator = Authenticator()
	private let session = URLSession(configuration: .default)
	
	private var currentSong: Song?
	
	private weak var delegate: SongChangeDelegate?
	
	init(_ delegate: SongChangeDelegate? = nil) {
		
		// Store the clientID outside of the project and source for development
		let idURL = Bundle.main.url(forResource: ".client-id", withExtension: nil)!
		clientID = try! String(contentsOf: idURL).trimmingCharacters(in: .whitespacesAndNewlines)
		
		self.delegate = delegate
	}
	
	func auth(completion: @escaping () -> Void) {
		
		authenticator.auth(forClient: clientID) { result in
			
			switch result {
			case let .success(state):
				self.authState = state
				completion()
			case let .failure(error):
				print("Error logging in \(error)")
				completion()
			}
		}
	}
	
	// MARK: Spotify API functions
	func image(for url: URL, completion: @escaping (Data?) -> Void) {
		
		let request = URLRequest(url: url)
		let task = session.dataTask(with: request) { (data, _, _) in
			
			completion(data)
		}
		task.resume()
	}
	
	func activeDeviceID(completion: @escaping (String?) -> Void) {
		
		request(forMethod: "v1/me/player/devices") { responseData in
			
			DispatchQueue.main.async {
				
				guard
					let data = responseData,
					let jsonObject = try? JSONSerialization.jsonObject(with: data),
					let jsonDictionary = jsonObject as? [String: Any],
					let devices = jsonDictionary["devices"] as? [Any] else {
						
						return completion(nil)
				}
				
				for device in devices {
					
					guard let device = device as? [String: Any] else {
						continue
					}
					
					return completion(device["id"] as? String)
				}
				
				completion(nil)
			}
		}
	}
	
	func currentPlaybackInfo(completion: @escaping (String?) -> Void) {
		
		request(forMethod: "v1/me/player/") { responseData in
			
			DispatchQueue.main.async {
				
				guard let data = responseData else {
					return completion(nil)
				}
				
				let dataString = String(data: data, encoding: String.Encoding.utf8)
				completion(dataString)
			}
		}
	}
	
	func startPlayback(onDevice id: String, completion: @escaping () -> Void) {
		
		request(forMethod: "v1/me/player/play", params: ["device_id": id]) { _ in
			
			DispatchQueue.main.async {
				
				completion()
			}
		}
	}
	
	func features(forSong song: Song, completion: @escaping (Features?) -> Void) {
		
		request(forMethod: "v1/audio-features/\(song.id)") { responseData in
			
			DispatchQueue.main.async {
				
				guard
					let data = responseData,
					let jsonObject = try? JSONSerialization.jsonObject(with: data),
					let jsonDictionary = jsonObject as? [String: Any] else {
						
					return completion(nil)
				}
				
				completion(Features(fromJSON: jsonDictionary))
			}
		}
	}
	
	func refreshCurrentSong(completion: ((Song?) -> Void)? = nil) {
		
		request(forMethod: "v1/me/player/currently-playing") { responseData in
			
			DispatchQueue.main.async {
				
				guard
					let data = responseData,
					let jsonObject = try? JSONSerialization.jsonObject(with: data),
					let jsonDictionary = jsonObject as? [AnyHashable: Any],
					let itemJSON = jsonDictionary["item"] as? [String: Any] else {
						
						completion?(nil)
						return
				}
				
				guard let fetched = Song(fromJSON: itemJSON) else {
					return
				}
				
				completion?(fetched)
				
				if self.currentSong == nil || fetched != self.currentSong! {
					self.currentSong = fetched
					self.delegate?.songDidChange(fetched)
				}
			}
		}
	}
	
	static func url(base: URL, method: String, params: [String: String]?) -> URL {
		
		var components = URLComponents(url: base.appendingPathComponent(method), resolvingAgainstBaseURL: false)!
		
		var queryItems = [URLQueryItem]()
		if let params = params {
			
			for (key, value) in params {
				queryItems.append(URLQueryItem(name: key, value: value))
			}
		}
		
		components.queryItems = queryItems
		return components.url!
	}
	
	// MARK: Private functions
	private func request(forMethod method: String, params: [String: String]? = nil, completion: @escaping (Data?) -> Void) {
		
		guard
			let token = authState?.token,
			let tokenType = authState?.tokenType else {
				
				return completion(nil)
		}
		
		var request = URLRequest(url: SpotifyAPI.url(base: apiBaseURL, method: method, params: params))
		request.addValue("\(tokenType) \(token)", forHTTPHeaderField: "Authorization")
		
		let task = session.dataTask(with: request) { (data, _, _) in
			
			completion(data)
		}
		task.resume()
	}
}

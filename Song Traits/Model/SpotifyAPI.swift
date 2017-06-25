//
//  SpotifyAPI.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation

protocol SongChangeDelegate: class {
	func songDidChange(_ song: Song)
}

class SpotifyAPI {
	
	private let clientID: String
	private let clientSecret: String
	
	private let apiBaseURL = URL(string: "https://api.spotify.com")!
	
	private var authState: AuthState?
	private let authorizer: Authorizer
	private let session = URLSession(configuration: .default)
	
	private var lastSong: Song?
	
	weak var delegate: SongChangeDelegate?
	
	init(_ delegate: SongChangeDelegate?) {
		
		let idURL = Bundle.main.url(forResource: ".client-id", withExtension: nil)!
		let secretURL = Bundle.main.url(forResource: ".client-secret", withExtension: nil)!
		
		clientID = try! String(contentsOf: idURL).trimmingCharacters(in: .whitespacesAndNewlines)
		clientSecret = try! String(contentsOf: secretURL).trimmingCharacters(in: .whitespacesAndNewlines)
		
		authorizer = Authorizer()
		
		self.delegate = delegate
	}
	
	func auth(completion: @escaping () -> Void) {
		
		authorizer.auth(forClient: clientID) { result in
			
			switch result {
			case let .success(state):
				self.authState = state
				print("Successfully logged in")
				completion()
			case let .failure(error):
				print("Error logging in \(error)")
				completion()
			}
		}
	}
	
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
	
	func currentSong(completion: ((Song?) -> Void)?) {
		
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
				
				guard let current = Song(fromJSON: itemJSON) else {
					return
				}
				
				completion?(current)
				
				if self.lastSong == nil || current != self.lastSong! {
					self.delegate?.songDidChange(current)
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

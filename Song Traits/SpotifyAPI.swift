//
//  SpotifyAPI.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation
import Swifter

class SpotifyAPI {
	
	private let clientID: String
	private let clientSecret: String
	
	private let apiBaseURL = URL(string: "https://api.spotify.com")!
	
	private var authState: AuthState?
	private let authorizer: Authorizer
	private let session = URLSession(configuration: .default)
	
	init() {
		
		let idURL = Bundle.main.url(forResource: ".client-id", withExtension: nil)!
		let secretURL = Bundle.main.url(forResource: ".client-id", withExtension: nil)!
		
		clientID = try! String(contentsOf: idURL).trimmingCharacters(in: .whitespacesAndNewlines)
		clientSecret = try! String(contentsOf: secretURL).trimmingCharacters(in: .whitespacesAndNewlines)
		
		authorizer = Authorizer()
	}
	
	func auth() {
		
		authorizer.auth(forClient: clientID) { result in
			
			switch result {
			case let .success(state):
				self.authState = state
				print("Successfully logged in success")
			case let .failure(error):
				print("Error logging in \(error)")
			}
		}
	}
	
	static func url(_ base: URL, method: String, params: [String: String]?) -> URL {
		
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
}

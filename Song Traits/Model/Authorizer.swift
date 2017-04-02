//
//  Authorizer.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation
import Swifter

enum AuthResult {
	case success(AuthState)
	case failure(String)
}

class Authorizer {
	
	private let accountsBaseURL = URL(string: "https://accounts.spotify.com")!
	
	private let server: HttpServer
	private let port: in_port_t = 5050
	private let callbackMethod = "auth-callback"
	private let stateToken: String
	
	private var completionHandler: ((AuthResult) -> Void)?
	
	init() {
		
		stateToken = UUID().uuidString
		
		server = HttpServer()
		try! server.start(port)
	}
	
	func auth(forClient clientID: String, completion: @escaping (AuthResult) -> Void) {
		
		let params = [
			"client_id": clientID,
			"response_type": "token",
			"redirect_uri": "http://localhost:\(port)/\(callbackMethod)",
			"state": stateToken,
			"scope": "user-read-playback-state"]
		
		server["/\(callbackMethod)"] = { request in
			
			if let body = self.getRedirectHTML(request) {
				return .ok(.html(body))
			} else {
				
				let result = self.parse(request)
				
				switch result {
				case let .success(state):
					
					completion(.success(state))
					return .ok(.html("Successfully logged in"))
				case let .failure(error):
					
					completion(.failure(error))
					return .badRequest(.html(error))
				}
			}
		}
		
		let url = authURL(method: "authorize", params: params)
		
		NSWorkspace.shared().open(url)
	}
	
	
	private func authURL(method: String, params: [String: String]?) -> URL {
		
		return SpotifyAPI.url(base: accountsBaseURL, method: method, params: params)
	}
	
	private func getRedirectHTML(_ request: HttpRequest) -> String? {
		
		if request.queryParams.isEmpty {
			return "<script> function passParams() { window.location = \"http://localhost:\(port)/\(callbackMethod)?\" + window.location.hash.substr(1); } window.onload = passParams</script>"
		} else {
			return nil
		}
	}
	
	private func parse(_ request: HttpRequest) -> AuthResult {
		
		guard
			let receivedToken = request.queryParams.first(where: { $0.0 == "state" }),
			receivedToken.1 == stateToken else {
				
				return .failure("Error validating state token")
		}
		
		guard let auth = AuthState(request.queryParams) else {
			
			let err = request.queryParams.first { $0.0 == "error" }?.1 ?? "none"
			return .failure("Error loading query params \(request.queryParams)\n\nError: \(err)")
		}
		
		return .success(auth)
	}
}

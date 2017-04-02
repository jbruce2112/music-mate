//
//  AuthState.swift
//  Song Traits
//
//  Created by John on 4/2/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Foundation

struct AuthState {
	
	let token: String
	let tokenType: String
	let expiresAt: Date
	
	init?(_ params: [(String, String)]) {
		
		guard
			let token = params.first(where: { $0.0 == "access_token" }),
			let tokenType = params.first(where: { $0.0 == "token_type" }),
			let expiresIn = params.first(where: { $0.0 == "expires_in" }) else {
				
				return nil
		}
		
		self.token = token.1
		self.tokenType = tokenType.1
		
		guard let expireInterval = TimeInterval(expiresIn.1) else {
			return nil
		}
		
		self.expiresAt = Date() + expireInterval
	}
}

//
//  DeviceCodeDTO.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

import Foundation

struct DeviceCodeDTO: Decodable, Sendable {
    enum CodingKeys: String, CodingKey {
        case deviceCode = "device_code"
        case expiresIn = "expires_in"
        case interval
        case userCode = "user_code"
        case verificationUri = "verification_uri"
    }
    
    let deviceCode: String
    let expiresIn: Int
    let interval: Int
    let userCode: String
    let verificationUri: URL
}

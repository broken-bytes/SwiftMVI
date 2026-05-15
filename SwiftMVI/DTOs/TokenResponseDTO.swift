//
//  TokenResponseDTO.swift
//  SwiftMVI
//
//  Created by Marcel Kulina on 15.05.26.
//

struct TokenResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        
    }
    
    let accessToken: String
}

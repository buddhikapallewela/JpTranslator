//
//  WbAPIDataModels.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import Foundation

/// Translation API request model
struct TranslationReqeust: Codable {
    var app_id:String
    var request_id: String
    var sentence: String
    var output_type: String
}

/// Translation API Suceess response model
struct TranslationSuccessResponse: Decodable {
    let converted: String
    let output_type: String
    let request_id: String
}

/// Translation API error response model
struct TranslationErrorResponse: Error, Decodable {
    let code: Int
    let message: String
}

///  API request common model
enum TranslationResponse<T: Decodable>: Decodable {
    case success(T)
    case failure(TranslationErrorResponse)
    
    private enum CodingKeys: String, CodingKey {
        case success
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if try container.decode(Bool.self, forKey: .success) {
            self = .success(try T(from: decoder))
        } else {
            self = .failure(try container.decode(TranslationErrorResponse.self, forKey: .error))
        }
    }
}

//
//  KanaKanaTranslatorAPIClient.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import Foundation

/// Constants
private struct Constants {
    static let applicationId = "82d2a5b35ed59076f88970af301c59e94076117da3c22ef8e22889e1d2646ebc"
    static let baseUrl = "https://labs.goo.ne.jp/api/hiragana"
    static let unknownErrorCode = 400
    static let unknownServerErrorMessage = "Translation data retrieve Error, Please try again later..."
    static let defaultRequestId = "Request1"
}

enum TranslationOutputType: String{
    case hiragana, katakana
}

/// Translator API Client Protocol
protocol KanaTranslatorAPIClientProtocol {
    func translateText(originalText: String, outputMethod: String, completion: @escaping(Result<TranslationSuccessResponse, TranslationErrorResponse>) -> Void)
}

/// Translator API Client
final class KanaTranslatorAPIClient: KanaTranslatorAPIClientProtocol {
    
    /// Web API client
    private let client: HttpClientProtocol
    
    init(client: HttpClientProtocol = HttpClient()) {
        self.client = client
    }
    
    func translateText(originalText: String, outputMethod: String, completion: @escaping (Result<TranslationSuccessResponse, TranslationErrorResponse>) -> Void) {
        let params = [
            "app_id": Constants.applicationId,
            "request_id": Constants.defaultRequestId,
            "sentence": originalText,
            "output_type": outputMethod
        ]
        
        guard let url = URL(string: Constants.baseUrl) else { return }
        self.client.post(url: url, parameters: params, completionHandler: { (data, error) in
            
            if let errorResponse = error {
                completion(.failure(TranslationErrorResponse(code: Constants.unknownErrorCode, message: errorResponse.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(TranslationErrorResponse(code: Constants.unknownErrorCode, message: Constants.unknownServerErrorMessage)))
                return
            }
            
            guard let jsonData = try? JSONDecoder().decode(TranslationSuccessResponse.self, from: data) else {
                print("json変換に失敗しました")
                completion(.failure(TranslationErrorResponse(code: Constants.unknownErrorCode, message: Constants.unknownServerErrorMessage)))
                return
            }
            
            completion(.success(jsonData))
        })
    }
}

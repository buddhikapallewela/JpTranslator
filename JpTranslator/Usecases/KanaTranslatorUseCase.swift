//
//  KanaTranslatorUseCase.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import Foundation

/// Usecase protocol for Kana Translator
protocol KanaTranslatorUseCaseProtocol {
    func translateText(originalText: String, outputMethod: String, completion: @escaping(Result<KanaTranslatorUseCase.KanaTranslationSuccessResponse, KanaTranslatorUseCase.KanaTranslationFailureResponse>) -> Void)
}

/// Usecase for Kana Translator
final class KanaTranslatorUseCase {
    
    private let apiClient: TranslatorAPIClientProtocol
    
    init(apiClient: TranslatorAPIClientProtocol = TranslatorAPIClient()) {
        self.apiClient = apiClient
    }
}

// MARK: Internal data structures
extension KanaTranslatorUseCase {
    
    /// Kana Translator success response model
    struct KanaTranslationSuccessResponse {
        let output: String
    }

    /// Kana Translator  failure response model
    struct KanaTranslationFailureResponse: Error {
        let errorTitle: String
        let errorMessage: String
        let statusCode: Int
    }
}

// MARK: KanaTranslatorUseCaseProtocol conformation
extension KanaTranslatorUseCase: KanaTranslatorUseCaseProtocol {
    
    /// Translate input text
    /// - Parameters:
    ///   - originalText: originalText to translate
    ///   - outputMethod: output method (hiragana or katakana)
    ///   - completion: completion handler
    func translateText(originalText: String, outputMethod: String, completion: @escaping (Result<KanaTranslatorUseCase.KanaTranslationSuccessResponse, KanaTranslatorUseCase.KanaTranslationFailureResponse>) -> Void) {
        self.apiClient.translateText(originalText: originalText, outputMethod: outputMethod, completion: { result in
            switch result {
            case .success(let response):
                completion(.success(KanaTranslatorUseCase.KanaTranslationSuccessResponse(output: response.converted)))
            case .failure(let errorInfo):
                let title = "Translation failure"
                completion(.failure(KanaTranslatorUseCase.KanaTranslationFailureResponse(errorTitle: title, errorMessage: errorInfo.message, statusCode: errorInfo.code)))
            }
        })
    }
}

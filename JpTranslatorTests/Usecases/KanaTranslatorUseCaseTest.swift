//
//  KanaTranslatorUseCaseTest.swift
//  JpTranslatorTests
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import XCTest

class KanaTranslatorUseCaseTest: XCTestCase {
    func testTranslateTextSuccessHiragana() {
        let stub = KanaTranslatorAPIClientProtocolStub()
        let client = KanaTranslatorUseCase(apiClient: stub)
        client.translateText(originalText: "今日はいい天気です", outputMethod: "hiragana") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.output , "きょうは いい てんきです")
                XCTAssert(true)
            case.failure:
               XCTAssert(false)
            }
        }
    }
    
    func testTranslateTextSuccessKatakana() {
        let stub = KanaTranslatorAPIClientProtocolStub()
        let client = KanaTranslatorUseCase(apiClient: stub)
        client.translateText(originalText: "今日はいい天気です", outputMethod: "katakana") { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.output , "キョウハ イイ テンキデス")
            case.failure:
               XCTAssert(false)
            }
        }
    }
    
    func testTranslateTextFailure() {
        let stub = KanaTranslatorAPIClientProtocolStub()
        let client = KanaTranslatorUseCase(apiClient: stub)
        client.translateText(originalText: "キョウハ イイ テンキデス", outputMethod: "aaaaa") { result in
            switch result {
            case .success:
                XCTAssert(false)
            case.failure:
               XCTAssert(true)
            }
        }
    }
}

extension KanaTranslatorUseCaseTest {
    
    private class KanaTranslatorAPIClientProtocolStub: KanaTranslatorAPIClientProtocol {
        func translateText(originalText: String, outputMethod: String, completion: @escaping (Result<TranslationSuccessResponse, TranslationErrorResponse>) -> Void) {
            switch outputMethod {
            case "hiragana":
                completion(.success(TranslationSuccessResponse(converted: "きょうは いい てんきです", output_type: "hiragana", request_id: "R001")))
            case "katakana":
                completion(.success(TranslationSuccessResponse(converted: "キョウハ イイ テンキデス", output_type: "katakana", request_id: "R001")))
            default:
                completion(.failure(TranslationErrorResponse(code: 400, message: "Data Error")))
            }
        }
    }
}

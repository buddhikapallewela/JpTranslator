//
//  KanaTranslatorAPIClientTest.swift
//  JpTranslatorTests
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import XCTest

class KanaTranslatorAPIClientTest: XCTestCase {
    func testTranslateTextSuccess() {
        let stub = HttpClientStub()
        stub.setResponseData(responseData: createTranslataionSuccessData())
        let client = KanaTranslatorAPIClient(client: stub)
        client.translateText(originalText: "今日はいい天気です", outputMethod: "hiragana") { result in
            switch result {
            case .success:
                XCTAssert(true)
            case.failure:
                XCTAssert(false)
            }
        }
    }
    
    func testTranslateTextFailure() {
        let stub = HttpClientStub()
        stub.setResponseData(responseData: createTranslataionErrorData())
        let client = KanaTranslatorAPIClient(client: stub)
        client.translateText(originalText: "....", outputMethod: "hiragana") { result in
            switch result {
            case .success:
                XCTAssert(false)
            case.failure:
                XCTAssert(true)
            }
        }
    }
}

extension KanaTranslatorAPIClientTest {
    
    private class HttpClientStub: HttpClientProtocol {
        var responseData: [String: Any] = [String: Any]()
        
        func setResponseData(responseData: [String: Any]) {
            self.responseData = responseData
        }
        
        func post(url: URL, parameters: [String : String], completionHandler: @escaping (Data?, Error?) -> Void) {
            do {
                //Convert to Data
                let jsonData = try JSONSerialization.data(withJSONObject: self.responseData, options: .prettyPrinted)
                completionHandler(jsonData, nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createTranslataionSuccessData() -> [String: Any]  {
        
        let jsonObject: [String: String] = [
            "converted": "キョウハ イイ テンキデス",
            "output_type": "str",
            "request_id": "1111"
        ]
        
        return jsonObject
    }
    
    func createTranslataionErrorData() -> [String: Any]  {
        
        let jsonObject: [String: Any] = [
            "error": [
                "code": 400,
                "message": "Invalid app_id"
            ]
        ]
        
        return jsonObject
    }
}

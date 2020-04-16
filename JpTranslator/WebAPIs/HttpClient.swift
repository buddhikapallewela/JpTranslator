//
//  HttpClient.swift
//  JpTranslator
//
//  Created by Buddhika Pallewela on 2020/04/16.
//  Copyright © 2020 Buddhika Pallewela. All rights reserved.
//

import Foundation

import Foundation

/// URLSessionProtocol Protocol
protocol HttpClientProtocol {
    func post(url: URL, parameters: [String: String], completionHandler: @escaping (Data?, Error?) -> Void)
}

extension URLSession: HttpClientProtocol {
    func post(url: URL, parameters: [String: String], completionHandler: @escaping (Data?, Error?) -> Void) {
        
        // Prepare URL Request Object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let bodyData = try? JSONSerialization.data(withJSONObject: parameters) else {
            print("json生成に失敗しました")
            return
        }
        request.httpBody = bodyData
        
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                // Check for Error
                if let error = error {
                    print("Error occured : \(error)")
                    completionHandler(data, error)
                    return
                }
                
                // Convert HTTP Response Data to a String
                if let data = data {
                    completionHandler(data, error)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
        task.resume()
    }
}

/// Http client to access web APIs
class HttpClient: HttpClientProtocol {
    private let session: HttpClientProtocol
    
    init(session: HttpClientProtocol = URLSession.shared) {
        self.session = session
    }
    
    func post(url: URL, parameters: [String: String], completionHandler: @escaping (Data?, Error?) -> Void) {
        session.post(url: url, parameters: parameters) { data, error in
            completionHandler(data, error)
        }
    }
}

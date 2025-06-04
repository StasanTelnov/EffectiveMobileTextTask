//
//  Extensions.swift
//  NetworkKit
//
//  Created by Stas Telnov on 04.06.2025.
//

import Foundation

extension URLSession {
    func asyncData(for request: URLRequest) async throws -> (Data, URLResponse) {
        if #available(iOS 15.0, *) {
            return try await data(for: request)
        } else if #available(iOS 13.0, *) {
            return try await withCheckedThrowingContinuation { continuation in
                let task = self.dataTask(with: request) { data, response, error in
                    guard let data, let response else {
                        let error = error ?? URLError(.badServerResponse)
                        return continuation.resume(throwing: error)
                    }
                    
                    continuation.resume(returning: (data, response))
                }
                task.resume()
            }
        } else {
            fatalError("Fucking xcode!)) Deploy target to ios 15+")
        }
    }
}

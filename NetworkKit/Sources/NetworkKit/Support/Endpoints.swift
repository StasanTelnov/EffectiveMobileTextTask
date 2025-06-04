//
//  Endpoints.swift
//  NetworkKit
//
//  Created by Stas Telnov on 04.06.2025.
//

import Foundation

protocol EndpointsProtocol {
    static var path: URL { get }
    static var method: String { get }
    static var contentType: String { get }
}

struct Endpoints {
    private static let baseURL = URL(string: "https://dummyjson.com")!
    
    struct TodosList: EndpointsProtocol {
        
        static let path = URL(string: "\(baseURL.absoluteString)/todos")!
        static let method = "GET"
        static let contentType = "application/json"
    }
}

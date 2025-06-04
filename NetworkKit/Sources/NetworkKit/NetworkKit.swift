// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

// MARK: - Protocol

public protocol NetworkManager {
    func fetchTodos(limit: Int) async -> Result<TodoListResponseModel, Error>
}

// MARK: - NetworkKit

public class NetworkKit {
    
    // MARK: properties
    
    private lazy var session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    // MARK: life cicle
    
    public init() {}
    
    // MARK: execute requests
    
    private func perform<Target: Decodable>(endpoint: EndpointsProtocol.Type, parameters: [String: Any] = [:]) async throws -> Target {
        var finalUrl = endpoint.path
        
        if !parameters.isEmpty,
           var components = URLComponents(url: endpoint.path, resolvingAgainstBaseURL: false) {
            components.queryItems = parameters.map { URLQueryItem(name: $0, value: String(describing: $1)) }
            guard let urlWithParameters = components.url else {
                throw URLError(.badURL)
            }
            finalUrl = urlWithParameters
        }

        var request = URLRequest(url: finalUrl)
        request.httpMethod = endpoint.method
        request.setValue(endpoint.contentType, forHTTPHeaderField: "Content-Type")
        
        return try await perform(request: request)
    }
    
    private func perform<Target: Decodable>(request: URLRequest) async throws -> Target {
        do {
            let (data, response) = try await session.asyncData(for: request)
            return try handle(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    private func handle<Target: Decodable>(data: Data?, response: URLResponse?) throws -> Target {
        guard let response,
                let data else {
            throw URLError(.cannotParseResponse)
        }
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            let target = try decoder.decode(Target.self, from: data)
            return target
        } catch {
            print("JSON parsing error: \(error)\n\ndata: \(String(data: data, encoding: .utf8) ?? "")")
            throw error
        }
    }
}

// MARK: - NetworkManager methods

extension NetworkKit: NetworkManager {
    public func fetchTodos(limit: Int = Int.max) async -> Result<TodoListResponseModel, Error> {
        let request = TodoListRequestModel(limit: limit)
        let result: TodoListResponseModel
        do {
            result = try await perform(endpoint: Endpoints.TodosList.self, parameters: ["limit": limit])
        } catch {
            return (.failure(error))
        }
        return (.success(result))
    }
}

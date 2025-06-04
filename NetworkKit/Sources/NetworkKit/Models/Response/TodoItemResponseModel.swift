//
//  TodoItemResponseModel.swift
//  NetworkKit
//
//  Created by Stas Telnov on 04.06.2025.
//

public struct TodoItemResponseModel: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
}

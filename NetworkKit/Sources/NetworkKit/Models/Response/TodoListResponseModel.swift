//
//  TodoListResponseModel.swift
//  NetworkKit
//
//  Created by Stas Telnov on 04.06.2025.
//

public struct TodoListResponseModel: Decodable {
    let todos: [TodoItemResponseModel]
    let total: Int
}

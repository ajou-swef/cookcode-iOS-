//
//  NetworkError.swift
//  Cookcode
//
//  Created by 노우영 on 2023/04/27.
//

import Foundation

struct ServiceError: Codable, Error {
    let message: String
    let status: Int
}
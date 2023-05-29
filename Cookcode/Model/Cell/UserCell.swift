//
//  UserCell.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/29.
//

import Foundation

struct UserCell: Identifiable, Mock {
    static func mock() -> UserCell {
        UserCell(userName: "하하하", imageURL: "https://picsum.photos/200/300")
    }
    
    let id: String = UUID().uuidString
    let userName: String
    let imageURL: String
}

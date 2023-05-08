//
//  RecipeCell.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/02.
//

import Foundation

struct RecipeCell: SearchedCell {
    var type: RecipeCell.Type {
        RecipeCell.self
    }
    
    var id: String = UUID().uuidString
    
    static func mock() -> RecipeCell {
        RecipeCell(thumbnail: "https://picsum.photos/200", title: "맛있는 요리", userName: "Page")
    }
    
    typealias MockType = RecipeCell
    
    var thumbnail: String
    var title: String
    var userName: String
}

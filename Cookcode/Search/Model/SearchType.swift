//
//  SearchType.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/01.
//

import Foundation

enum SearchType: String, CaseIterable {
    case recipe = "레시피"
    case user = "유저"
    case cookie = "쿠키"
    case follower = "구독자"
    
    static func profileSearchType() -> [SearchType] {
        return [.recipe, .cookie, .follower]
    }
    
    static func searchType() -> [SearchType] {
        return [.recipe, .cookie, .user]
    }
}


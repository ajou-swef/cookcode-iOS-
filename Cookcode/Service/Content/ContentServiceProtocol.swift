//
//  Content.swift
//  Cookcode
//
//  Created by 노우영 on 2023/05/01.
//

import Alamofire
import Foundation

protocol ContentServiceProtocol {
    func postPhotos(_ data: [Data]) async -> Result<PhotoResponse, ServiceError>
    func postVideos(_ data: [Data]) async -> Result<VideoResponse, ServiceError>
}
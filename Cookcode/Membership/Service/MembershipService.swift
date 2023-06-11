//
//  MembershipService.swift
//  Cookcode
//
//  Created by 노우영 on 2023/06/11.
//

import Alamofire
import SwiftUI

final class MembershipService {
    func createMembership(dto: MembershipGradeFormDto) async -> Result<DefaultResponse, ServiceError>{
        let url = "\(BASE_URL)/api/v1/membership"
        
        let headers: HTTPHeaders = [
            "accessToken" : UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY) ?? ""
        ]
        
        let response = await AF.request(url, method: .post, parameters: dto, encoder: .json, headers: headers)
            .serializingDecodable(DefaultResponse.self).response
        
        print("\(response.debugDescription)")
        
        return response.result.mapError { err in
            let serviceErorr = response.data.flatMap { try? JSONDecoder().decode(ServiceError.self, from: $0) }
            return serviceErorr ?? .decodeError()
        }
    }
}

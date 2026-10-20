//
//  AuthDTO.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import Foundation

enum SocialProvider: String, Codable, CaseIterable, Hashable {
    case apple, kakao, naver, google
}

struct AuthResultDTO: Codable, Hashable {
    // 서버가 최초 가입으로 판단했는지 (true면 약관 -> 프로필 설정 진행)
    let isFirstTime: Bool
    let accessToken: String?
    let refreshToken: String?
}

//
//  AuthRepository.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import Foundation

enum AuthError: Error, Equatable {
    case cancelled
    case network
    case invalidResponse
    case invalidCredentials
    case emailTaken
    case nicknameTaken
    case unknown
}

// TODO: [백엔드] 토큰 저장(Keychain)과 갱신은 연동 시 구현체에서 처리
protocol AuthRepository {
    func signIn(with provider: SocialProvider) async throws -> AuthResultDTO
    func signIn(email: String, password: String, autoLogin: Bool) async throws -> AuthResultDTO
    // TODO: [백엔드] 이메일 중복 확인 API 스펙 확정 필요
    func checkEmailAvailability(_ email: String) async throws -> Bool
    func signUp(email: String, password: String) async throws -> AuthResultDTO
    func acceptTerms(marketingAgreed: Bool) async throws
    func completeProfile(nickname: String) async throws
    func signOut() async throws
}

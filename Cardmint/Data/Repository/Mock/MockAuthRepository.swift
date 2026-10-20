//
//  MockAuthRepository.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import Foundation

struct MockAuthRepository: AuthRepository {
    var delay: Duration = .milliseconds(600)
    var isFirstTime: Bool = true

    func signIn(with provider: SocialProvider) async throws -> AuthResultDTO {
        try await Task.sleep(for: delay)
        return AuthResultDTO(isFirstTime: isFirstTime, accessToken: nil, refreshToken: nil)
    }

    func signIn(email: String, password: String, autoLogin: Bool) async throws -> AuthResultDTO {
        try await Task.sleep(for: delay)
        // 이메일 로그인은 기존 회원이므로 isFirstTime false
        return AuthResultDTO(isFirstTime: false, accessToken: nil, refreshToken: nil)
    }

    func checkEmailAvailability(_ email: String) async throws -> Bool {
        try await Task.sleep(for: .milliseconds(400))
        // 목업: "taken"으로 시작하는 이메일은 이미 가입된 것으로 처리 (중복 상태 테스트용)
        return !email.lowercased().hasPrefix("taken")
    }

    func signUp(email: String, password: String) async throws -> AuthResultDTO {
        try await Task.sleep(for: delay)
        return AuthResultDTO(isFirstTime: true, accessToken: nil, refreshToken: nil)
    }

    func acceptTerms(marketingAgreed: Bool) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }

    func completeProfile(nickname: String) async throws {
        try await Task.sleep(for: .milliseconds(300))
    }

    func signOut() async throws {
        try await Task.sleep(for: .milliseconds(600))
    }
}

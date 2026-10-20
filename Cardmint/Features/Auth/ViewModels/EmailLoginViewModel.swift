//
//  EmailLoginViewModel.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

@Observable
final class EmailLoginViewModel {
    private(set) var email = ""
    private(set) var password = ""
    private(set) var autoLogin = true
    private(set) var serverError: String?
    private(set) var isSubmitting = false
    var toastMessage: String?

    private let auth: any AuthRepository

    init(auth: any AuthRepository) {
        self.auth = auth
    }

    var errorMessage: String? { serverError }

    var canSubmit: Bool {
        InputRule.isValidEmail(email) && !password.isEmpty
    }

    func updateEmail(_ value: String) {
        email = value
        serverError = nil
    }

    func updatePassword(_ value: String) {
        password = value
        serverError = nil
    }

    func toggleAutoLogin() {
        autoLogin.toggle()
    }

    /// 성공 시 결과 반환, 실패 시 nil (오류는 필드 하단 문구 또는 토스트로 표시)
    func submit() async -> AuthResultDTO? {
        guard canSubmit, !isSubmitting else { return nil }
        isSubmitting = true
        defer { isSubmitting = false }

        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        do {
            return try await auth.signIn(email: trimmedEmail, password: password, autoLogin: autoLogin)
        } catch AuthError.invalidCredentials {
            // TODO: [Figma 확인] 로그인 실패 문구 확정 필요 (Figma에 없음)
            serverError = "이메일 또는 비밀번호를 확인해 주세요"
            return nil
        } catch AuthError.network {
            toastMessage = "네트워크 연결을 확인해 주세요"
            return nil
        } catch {
            toastMessage = "잠시 후 다시 시도해 주세요"
            return nil
        }
    }
}

//
//  EmailSignUpViewModel.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

@Observable
final class EmailSignUpViewModel {
    enum EmailStatus: Equatable { case idle, checking, available, taken }

    private(set) var email = ""
    private(set) var password = ""
    private(set) var passwordConfirm = ""
    private(set) var emailStatus: EmailStatus = .idle
    private(set) var isSubmitting = false
    var toastMessage: String?

    @ObservationIgnored private var emailCheckTask: Task<Void, Never>?
    private let auth: any AuthRepository

    init(auth: any AuthRepository) {
        self.auth = auth
    }

    // MARK: - 표시용 상태

    var emailHelper: String? {
        emailStatus == .available ? "사용 가능한 이메일이에요" : nil
    }

    var emailErrorMessage: String? {
        // TODO: [Figma 확인] 이메일 오류 문구 확정 필요 (Figma에 없음)
        if emailStatus == .taken { return "이미 가입된 이메일이에요" }
        if showsEmailFormatError { return "이메일 형식이 올바르지 않아요" }
        return nil
    }

    var passwordConfirmError: String? {
        guard !passwordConfirm.isEmpty, passwordConfirm != password else { return nil }
        return "비밀번호가 일치하지 않아요"
    }

    var canSubmit: Bool {
        InputRule.isValidEmail(trimmedEmail)
            && emailStatus != .taken
            && emailStatus != .checking
            && InputRule.isValidPassword(password)
            && passwordConfirm == password
            && !isSubmitting
    }

    // MARK: - 입력

    func updateEmail(_ value: String) {
        email = value
        scheduleEmailCheck()
    }

    func updatePassword(_ value: String) { password = value }

    func updatePasswordConfirm(_ value: String) { passwordConfirm = value }

    // MARK: - 제출

    /// 성공 시 결과 반환
    func submit() async -> AuthResultDTO? {
        guard canSubmit else { return nil }
        isSubmitting = true
        defer { isSubmitting = false }

        do {
            return try await auth.signUp(email: trimmedEmail, password: password)
        } catch AuthError.emailTaken {
            emailStatus = .taken
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

private extension EmailSignUpViewModel {
    var trimmedEmail: String { email.trimmingCharacters(in: .whitespaces) }

    /// 입력 중 "a@" 같은 미완성 상태에서는 오류를 띄우지 않음
    var showsEmailFormatError: Bool {
        guard let at = trimmedEmail.firstIndex(of: "@") else { return false }
        let domain = trimmedEmail[trimmedEmail.index(after: at)...]
        return !domain.isEmpty && !InputRule.isValidEmail(trimmedEmail)
    }

    /// 형식이 맞을 때만 0.5초 후 중복 확인. 입력이 이어지면 이전 확인은 취소
    func scheduleEmailCheck() {
        emailCheckTask?.cancel()
        guard InputRule.isValidEmail(trimmedEmail) else {
            emailStatus = .idle
            return
        }
        emailStatus = .checking
        let target = trimmedEmail
        emailCheckTask = Task { [weak self, auth] in
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }
            do {
                let available = try await auth.checkEmailAvailability(target)
                guard let self, !Task.isCancelled, target == self.trimmedEmail else { return }
                self.emailStatus = available ? .available : .taken
            } catch {
                // 확인 실패 시 가입 요청에서 서버가 다시 검증하므로 막지 않음
                guard let self, !Task.isCancelled, target == self.trimmedEmail else { return }
                self.emailStatus = .idle
            }
        }
    }
}

//
//  ProfileSetupViewModel.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

@Observable
final class ProfileSetupViewModel {
    static let minLength = 2
    static let maxLength = 10

    private(set) var nickname = ""
    private(set) var serverError: String?
    private(set) var isSubmitting = false
    var toastMessage: String?

    private let auth: any AuthRepository

    init(auth: any AuthRepository) {
        self.auth = auth
    }

    var count: Int { nickname.count }

    var helper: String {
        "2~10자 · 한글, 영문, 숫자 사용 가능 (\(count)/\(Self.maxLength))"
    }

    /// 입력 중에는 한글 조합 상태(자모)를 오류로 보지 않음
    private var hasDisallowedCharacter: Bool {
        nickname.contains { !InputRule.isNicknameAllowedWhileTyping($0) }
    }

    var errorMessage: String? {
        if hasDisallowedCharacter {
            // TODO: [Figma 확인] 오류 문구 확정 필요 (Figma에 없음)
            return "한글, 영문, 숫자만 사용할 수 있어요"
        }
        return serverError
    }

    var canSubmit: Bool {
        (Self.minLength...Self.maxLength).contains(count)
        && nickname.allSatisfy(InputRule.isNicknameFinalAllowed)
    }

    func updateNickname(_ value: String) {
        nickname = value
        serverError = nil
    }

    /// 최대 글자수 초과분 제거. 값이 한 번 바뀐 뒤 호출돼야 화면에 반영됨
    func enforceMaxLength() {
        guard nickname.count > Self.maxLength else { return }
        nickname = String(nickname.prefix(Self.maxLength))
    }

    /// 성공 여부 반환
    func submit() async -> Bool {
        guard canSubmit, !isSubmitting else { return false }
        isSubmitting = true
        defer { isSubmitting = false }

        do {
            try await auth.completeProfile(nickname: nickname)
            return true
        } catch AuthError.nicknameTaken {
            // TODO: [Figma 확인] 중복 닉네임 문구 확정 필요
            serverError = "이미 사용 중인 닉네임이에요"
            return false
        } catch AuthError.network {
            toastMessage = "네트워크 연결을 확인해 주세요"
            return false
        } catch {
            toastMessage = "잠시 후 다시 시도해 주세요"
            return false
        }
    }
}

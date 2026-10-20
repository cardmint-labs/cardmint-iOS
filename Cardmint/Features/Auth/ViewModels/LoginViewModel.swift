//
//  LoginViewModel.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

@Observable
final class LoginViewModel {
    private(set) var isLoading = false
    var toastMessage: String?
    
    private let auth: any AuthRepository
    
    init(auth: any AuthRepository) {
        self.auth = auth
    }
    
    // 성공 시 결과 반환. 취소는 조용히 nil, 실패는 토스트 메시지 설정 후 nil
    func signIn(with provider: SocialProvider) async -> AuthResultDTO? {
        guard !isLoading else { return nil }
        isLoading = true
        defer { isLoading = false }
        
        do {
            return try await auth.signIn(with: provider)
        } catch AuthError.cancelled {
            return nil
        } catch AuthError.network {
            toastMessage = "네트워크 연결을 확인해 주세요"
            return nil
        } catch {
            // TODO: [디자인] 로그인 실패 문구 확인 (Figma에 없음)
            toastMessage = "로그인에 실패했어요. 잠시 후 다시 시도해 주세요"
            return nil
        }
    }
}

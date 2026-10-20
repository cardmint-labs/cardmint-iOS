//
//  AppState.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

enum AppPhase: Equatable {
    case launching, signedOut, needsTerms, needsProfile, main
}

enum SystemBlock {
    case networkError
    case maintenance
    case forceUpdate
}

@Observable
final class AppState {
    private(set) var phase: AppPhase = .launching
    // TODO: [백엔드] 네트워크 레이어의 통신 실패(S-01), 점검 응답(S-02), 최소 지원 버전 미만(S-03) 수신 시 설정
    var systemBlock: SystemBlock? = nil
    
    func bootstrap() async {
        // TODO: [백엔드] 저장된 토큰으로 자동 로그인 판정 (유효 → .main / 약관·프로필 미완료 → 해당 phase / 없음 → .signedOut)
        try? await Task.sleep(for: .milliseconds(300))
        phase = .signedOut
    }
    
    // TODO: [백엔드] isFirstTime을 로그인 응답의 신규 가입 여부로 대체. 토큰 저장(Keychain)도 여기서 처리
    /// 이메일 로그인은 isFirstTime false, 소셜 최초 로그인·이메일 가입은 true (약관 → 프로필
    func completeLogin(isFirstTime: Bool) {
        phase = isFirstTime ? .needsTerms : .main
    }
    
    func acceptTerms() { phase = .needsProfile }
    func completeProfile() { phase = .main }
    
    
    // TODO: [백엔드] 서버 로그아웃 호출 + 토큰 삭제. 캐시·소켓 연결 정리 필요
    func signOut() { phase = .signedOut }
}

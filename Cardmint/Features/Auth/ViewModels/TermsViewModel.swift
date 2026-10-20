//
//  TermsViewModel.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

enum TermItem: CaseIterable, Hashable {
    case serviceUse, privacy, ageOver14, communityRules, marketing
    
    var title: String {
        switch self {
        case .serviceUse: "[필수] 서비스 이용약관 동의"
        case .privacy: "[필수] 개인정보 수집 및 이용 동의"
        case .ageOver14: "[필수] 만 14세 이상입니다"
        case .communityRules: "[필수] 커뮤니티 이용규칙 동의"
        case .marketing: "[선택] 마케팅 정보 수신 동의"
        }
    }
    
    var subtitle: String? {
        self == .marketing ? "이벤트 · 혜택 소식을 알림으로 받아볼 수 있어요" : nil
    }
    
    var isRequired: Bool { self != .marketing }
    
    /// 상세 보기 chevron 노출 여부 (Figma: 만 14세 항목만 없음)
    var hasDetail: Bool { self != .ageOver14 }
}

@Observable
final class TermsViewModel {
    private(set) var agreed: Set<TermItem> = []
    private(set) var isSubmitting = false
    var toastMessage: String?
    
    private let auth: any AuthRepository
    
    init(auth: any AuthRepository) {
        self.auth = auth
    }
    
    var isAllAgreed: Bool { agreed.count == TermItem.allCases.count }
    
    var canProceed: Bool {
        TermItem.allCases.filter(\.isRequired).allSatisfy { agreed.contains($0) }
    }
    
    func isAgreed(_ item: TermItem) -> Bool { agreed.contains(item) }
    
    func toggle(_ item: TermItem) {
        if agreed.contains(item) {
            agreed.remove(item)
        } else {
            agreed.insert(item)
        }
    }
    
    func toggleAll() {
        agreed = isAllAgreed ? [] : Set(TermItem.allCases)
    }
    
    /// 성공 여부 반환
    func submit() async -> Bool {
        guard canProceed, !isSubmitting else { return false }
        isSubmitting = true
        defer { isSubmitting = false }
        
        do {
            try await auth.acceptTerms(marketingAgreed: agreed.contains(.marketing))
            return true
        } catch AuthError.network {
            toastMessage = "네트워크 연결을 확인해 주세요"
            return false
        } catch {
            // TODO: [디자인] 약관 동의 실패 문구 확인 (Figma에 없음)
            toastMessage = "잠시 후 다시 시도해 주세요"
            return false
        }
    }
}

//
//  RootView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct RootView: View {
    @State private var appState = AppState()
    @State private var router = Router()

    var body: some View {
        content
            .animation(.easeOut(duration: 0.2), value: appState.phase)
            .overlay { systemOverlay }
            .environment(appState)
            .environment(router)
            .environment(\.appEnvironment, .mock)
            .task { await appState.bootstrap() }
            .onChange(of: appState.phase) { _, newPhase in
                if newPhase == .signedOut { router.reset() }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch appState.phase {
        case .launching:
            // TODO: 스플래시 화면 (Figma 확인 필요)
            PlaceholderView(title: "카드민트", subtitle: "스플래시")
        case .signedOut:
            AuthFlowView()
        case .needsTerms:
            // TODO: [백엔드] 뒤로가기 시 로그아웃(토큰 폐기) 처리 필요
            TermsView(onBack: { appState.signOut() })
        case .needsProfile:
            // TODO: [백엔드] 뒤로가기 시 처리 확정 필요 (임시: 로그아웃)
            ProfileSetupView(onBack: { appState.signOut() })
        case .main:
            MainTabView()
        }
    }

    // TODO: S-01~03 실제 화면으로 교체
    @ViewBuilder
    private var systemOverlay: some View {
        if let block = appState.systemBlock {
            switch block {
            case .networkError:
                PlaceholderView(title: "네트워크 오류", subtitle: "S-01") {
                    CMButton(title: "다시 시도", isFullWidth: true) {
                        appState.systemBlock = nil
                    }
                }
            case .maintenance:
                PlaceholderView(title: "서버 점검", subtitle: "S-02")
            case .forceUpdate:
                PlaceholderView(title: "업데이트가 필요해요", subtitle: "S-03")
            }
        }
    }
}

#Preview {
    RootView()
}

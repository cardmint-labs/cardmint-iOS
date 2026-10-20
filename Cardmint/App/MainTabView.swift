//
//  MainTabView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct MainTabView: View {
    @Environment(Router.self) private var router

    private let tabs: [CMTab] = CMTab.allCases.filter { $0 != .add }

    var body: some View {
        @Bindable var router = router

        ZStack {
            // 탭 전환 시 각 탭의 스택·상태가 유지되도록 4개를 모두 올려둠
            ForEach(tabs, id: \.self) { tab in
                TabStack(tab: tab, router: router)
                    .opacity(router.selectedTab == tab ? 1 : 0)
                    .allowsHitTesting(router.selectedTab == tab)
                    .accessibilityHidden(router.selectedTab != tab)
            }
        }
        // TODO: [기기 확인] 중앙 + 버튼 윗부분(탭바 영역 밖 28pt) 터치 동작, 검색 탭 키보드 표시 시 탭바 위치
        .safeAreaInset(edge: .bottom, spacing: 0) {
            // TODO: [Figma 확인] 푸시된 화면에서 탭바를 숨기는 규칙 확인 (상품상세·채팅방 등)
            if router.isAtRoot {
                CMTabBar(
                    selected: router.selectedTab,
                    hasChatBadge: false, // TODO: [백엔드] 안 읽은 채팅 유무로 교체
                    onSelect: router.select
                )
                .ignoresSafeArea(.keyboard)
            }
        }
        .fullScreenCover(isPresented: $router.isSellPresented) {
            // TODO: 판매 등록 E-01 화면으로 교체
            PlaceholderView(title: "판매 등록", subtitle: "E-01") {
                CMButton(title: "닫기", type: .outline, isFullWidth: true) {
                    router.isSellPresented = false
                }
            }
        }
    }
}

private struct TabStack: View {
    let tab: CMTab
    @Bindable var router: Router

    var body: some View {
        switch tab {
        case .home: stack($router.homePath)
        case .search: stack($router.searchPath)
        case .chat: stack($router.chatPath)
        case .my: stack($router.myPath)
        case .add: EmptyView()
        }
    }

    private func stack(_ path: Binding<[AppRoute]>) -> some View {
        NavigationStack(path: path) {
            TabRoot(tab: tab)
                .navigationDestination(for: AppRoute.self) { route in
                    RouteDestination(route: route)
                }
        }
    }
}

// TODO: 각 탭 실제 화면 구현 시 임시 버튼·PlaceholderView 제거 (홈 B-01, 검색 C-00, 채팅 F-01, 마이 H-01)
private struct TabRoot: View {
    let tab: CMTab
    @Environment(Router.self) private var router
    @Environment(AppState.self) private var appState

    var body: some View {
        switch tab {
        case .home:
            PlaceholderView(title: "홈", subtitle: "B-01") {
                CMButton(title: "상품 상세", type: .outline, isFullWidth: true) {
                    router.push(.productDetail(id: "mock-1"))
                }
                CMButton(title: "상세검색", type: .outline, isFullWidth: true) {
                    router.push(.detailSearch)
                }
                CMButton(title: "알림함", type: .outline, isFullWidth: true) {
                    router.push(.notifications)
                }
            }
        case .search:
            PlaceholderView(title: "검색 홈", subtitle: "C-00") {
                CMButton(title: "검색결과", type: .outline, isFullWidth: true) {
                    router.push(.searchResult(query: "리자몽"))
                }
            }
        case .chat:
            PlaceholderView(title: "채팅 목록", subtitle: "F-01") {
                CMButton(title: "채팅방", type: .outline, isFullWidth: true) {
                    router.push(.chatRoom(id: "mock-1"))
                }
            }
        case .my:
            PlaceholderView(title: "마이", subtitle: "H-01") {
                CMButton(title: "프로필 수정", type: .outline, isFullWidth: true) {
                    router.push(.profileEdit)
                }
                CMButton(title: "로그아웃", type: .danger, isFullWidth: true) {
                    appState.signOut()
                }
            }
        case .add:
            EmptyView()
        }
    }
}

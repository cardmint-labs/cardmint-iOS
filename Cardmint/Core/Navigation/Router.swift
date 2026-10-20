//
//  Router.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

// TODO: 푸시 알림·딥링크 진입 처리 (알림 탭 → 채팅방·상품상세 등으로 경로 구성)
@Observable
final class Router {
    var selectedTab: CMTab = .home
    var isSellPresented: Bool = false

    // 탭별 NavigationStack 경로
    var homePath: [AppRoute] = []
    var searchPath: [AppRoute] = []
    var chatPath: [AppRoute] = []
    var myPath: [AppRoute] = []

    var isAtRoot: Bool {
        path(for: selectedTab).isEmpty
    }

    func push(_ route: AppRoute) {
        setPath(path(for: selectedTab) + [route], for: selectedTab)
    }

    func select(_ tab: CMTab) {
        switch tab {
        case .add:
            isSellPresented = true
        default:
            if tab == selectedTab {
                setPath([], for: tab) // 같은 탭을 다시 누르면 루트로
            } else {
                selectedTab = tab
            }
        }
    }

    func reset() {
        selectedTab = .home
        homePath = []
        searchPath = []
        chatPath = []
        myPath = []
        isSellPresented = false
    }

    private func path(for tab: CMTab) -> [AppRoute] {
        switch tab {
        case .home: return homePath
        case .search: return searchPath
        case .chat: return chatPath
        case .my: return myPath
        case .add: return []
        }
    }

    private func setPath(_ path: [AppRoute], for tab: CMTab) {
        switch tab {
        case .home: homePath = path
        case .search: searchPath = path
        case .chat: chatPath = path
        case .my: myPath = path
        case .add: break
        }
    }
}

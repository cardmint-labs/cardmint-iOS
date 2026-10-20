//
//  AuthFlowView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct AuthFlowView: View {
    @State private var path: [AuthRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(onEmail: { path.append(.emailLogin) })
                .toolbar(.hidden, for: .navigationBar)
                .navigationDestination(for: AuthRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: AuthRoute) -> some View {
        switch route {
        case .emailLogin:
            EmailLoginView(
                onSignUp: { path.append(.emailSignUp) },
                onFindPassword: { path.append(.passwordReset) }
            )
        case .emailSignUp:
            EmailSignUpView()
        case .passwordReset:
            // TODO: A-05 비밀번호 찾기 화면으로 교체
            AuthPlaceholderView(title: "비밀번호 찾기", code: "A-05")
        }
    }
}

// TODO: A-05 완료 시 삭제
private struct AuthPlaceholderView: View {
    let title: String
    let code: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            CMNavBar(style: .back, title: title, onLeading: { dismiss() })
            PlaceholderView(title: title, subtitle: code)
        }
        .background(Color.white.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    AuthFlowView()
        .environment(AppState())
}

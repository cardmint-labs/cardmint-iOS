//
//  LoginView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.appEnvironment) private var environment
    @Environment(AppState.self) private var appState
    @State private var viewModel: LoginViewModel?

    let onEmail: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 24)
            brandBlock
            Spacer(minLength: 24)
            bottomBlock
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cmToast(message: toastBinding)
        .task {
            if viewModel == nil {
                viewModel = LoginViewModel(auth: environment.auth)
            }
        }
    }
}

private extension LoginView {
    var isLoading: Bool { viewModel?.isLoading ?? false }

    var toastBinding: Binding<String?> {
        Binding(
            get: { viewModel?.toastMessage },
            set: { viewModel?.toastMessage = $0 }
        )
    }

    var brandBlock: some View {
        VStack(spacing: 0) {
            Image(.logoFull)
                .resizable()
                .scaledToFit()
                .frame(width: 176, height: 160)
            Text("등급카드, 믿고 거래하는 곳")
                .textStyle(.headingXLB)
                .foregroundStyle(Color.gray900)
                .padding(.top, 20)
            Text("PSA · BGS · BRG · CGC 등급카드만 거래해요")
                .textStyle(.bodySR)
                .foregroundStyle(Color.gray600)
                .padding(.top, 6)
        }
    }

    var bottomBlock: some View {
        VStack(spacing: 0) {
            CMButton(title: "이메일로 계속하기", size: .l, isFullWidth: true, action: onEmail)
                .disabled(isLoading)
            divider
                .padding(.top, 24)
            socialRow
                .padding(.top, 22)
            Text("계속 진행하면 서비스 이용약관 및 개인정보처리방침에\n동의하는 것으로 간주돼요.")
                .textStyle(.caption)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
        }
    }

    var divider: some View {
        HStack(spacing: 12) {
            Rectangle().fill(Color.gray200).frame(height: 1)
            Text("SNS 계정으로 시작하기")
                .textStyle(.caption)
                .foregroundStyle(Color.gray400)
                .fixedSize()
            Rectangle().fill(Color.gray200).frame(height: 1)
        }
    }

    var socialRow: some View {
        HStack(spacing: 16) {
            ForEach(SocialProvider.loginOrder, id: \.self) { provider in
                SocialCircleButton(provider: provider) { signIn(provider) }
            }
        }
        .disabled(isLoading)
    }

    func signIn(_ provider: SocialProvider) {
        guard let viewModel else { return }
        Task {
            guard let result = await viewModel.signIn(with: provider) else { return }
            appState.completeLogin(isFirstTime: result.isFirstTime)
        }
    }
}

private struct SocialCircleButton: View {
    let provider: SocialProvider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(provider.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(provider.accessibilityTitle)
    }
}

private extension SocialProvider {
    static let loginOrder: [SocialProvider] = [.apple, .kakao, .naver, .google]

    var icon: ImageResource {
        switch self {
        case .apple: .apple
        case .kakao: .kakao
        case .naver: .naver
        case .google: .google
        }
    }

    var accessibilityTitle: String {
        switch self {
        case .apple: "Apple로 시작하기"
        case .kakao: "카카오로 시작하기"
        case .naver: "네이버로 시작하기"
        case .google: "Google로 시작하기"
        }
    }
}

#Preview {
    LoginView(onEmail: {})
        .environment(AppState())
}

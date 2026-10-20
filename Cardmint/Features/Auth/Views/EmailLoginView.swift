//
//  EmailLoginView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct EmailLoginView: View {
    @Environment(\.appEnvironment) private var environment
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EmailLoginViewModel?

    let onSignUp: () -> Void
    let onFindPassword: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            CMNavBar(style: .back, onLeading: { dismiss() })
            ScrollView {
                content
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .dismissKeyboardOnTap()
        .toolbar(.hidden, for: .navigationBar)
        .cmToast(message: toastBinding)
        .task {
            if viewModel == nil {
                viewModel = EmailLoginViewModel(auth: environment.auth)
            }
        }
    }
}

private extension EmailLoginView {
    var toastBinding: Binding<String?> {
        Binding(
            get: { viewModel?.toastMessage },
            set: { viewModel?.toastMessage = $0 }
        )
    }

    var emailBinding: Binding<String> {
        Binding(
            get: { viewModel?.email ?? "" },
            set: { viewModel?.updateEmail($0) }
        )
    }

    var passwordBinding: Binding<String> {
        Binding(
            get: { viewModel?.password ?? "" },
            set: { viewModel?.updatePassword($0) }
        )
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            fields
                .padding(.top, 44)
            options
                .padding(.top, 20)
            loginButton
                .padding(.top, 44)
            signUpRow
                .padding(.top, 20)
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("이메일로 로그인")
                .textStyle(.headingLB)
                .foregroundStyle(Color.gray900)
            Text("가입한 이메일과 비밀번호를 입력해 주세요.")
                .textStyle(.bodyMR)
                .foregroundStyle(Color.gray600)
        }
    }

    var fields: some View {
        VStack(alignment: .leading, spacing: 20) {
            CMTextField(
                // TODO: [Figma 확인] 플레이스홀더 문구 확정 필요 (Figma에 없음)
                placeholder: "이메일을 입력해 주세요",
                text: emailBinding,
                label: "이메일",
                keyboardType: .emailAddress
            )
            CMTextField(
                placeholder: "비밀번호를 입력해 주세요",
                text: passwordBinding,
                label: "비밀번호",
                errorMessage: viewModel?.errorMessage,
                isSecure: true
            )
        }
    }

    var options: some View {
        HStack(spacing: 0) {
            Button {
                viewModel?.toggleAutoLogin()
            } label: {
                HStack(spacing: 8) {
                    CMCheckbox(isSelected: viewModel?.autoLogin ?? true)
                    Text("자동 로그인")
                        .textStyle(.bodySM)
                        .foregroundStyle(Color.gray900)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("자동 로그인")
            .accessibilityValue((viewModel?.autoLogin ?? true) ? "선택됨" : "선택 안 됨")

            Spacer(minLength: 0)

            Button(action: onFindPassword) {
                Text("비밀번호 찾기")
                    .textStyle(.bodySM)
                    .foregroundStyle(Color.gray600)
            }
            .buttonStyle(.plain)
        }
    }

    var loginButton: some View {
        CMButton(title: "로그인", size: .l, isFullWidth: true) {
            guard let viewModel else { return }
            Task {
                guard let result = await viewModel.submit() else { return }
                // TODO: [백엔드] 토큰 저장(Keychain), autoLogin 값에 따른 보관 정책 처리
                appState.completeLogin(isFirstTime: result.isFirstTime)
            }
        }
        .disabled(!(viewModel?.canSubmit ?? false) || (viewModel?.isSubmitting ?? false))
    }

    var signUpRow: some View {
        HStack(spacing: 6) {
            Text("아직 회원이 아니신가요?")
                .textStyle(.bodySR)
                .foregroundStyle(Color.gray400)
            Button(action: onSignUp) {
                Text("회원가입")
                    .textStyle(.labelSM)
                    .foregroundStyle(Color.brandPrimary)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    NavigationStack {
        EmailLoginView(onSignUp: {}, onFindPassword: {})
    }
    .environment(AppState())
}

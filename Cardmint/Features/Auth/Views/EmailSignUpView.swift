//
//  EmailSignUpView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct EmailSignUpView: View {
    @Environment(\.appEnvironment) private var environment
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EmailSignUpViewModel?

    var body: some View {
        VStack(spacing: 0) {
            CMNavBar(style: .back, title: "회원가입", onLeading: { dismiss() })
            ScrollView {
                content
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .dismissKeyboardOnTap()
        .toolbar(.hidden, for: .navigationBar)
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomCTA }
        .cmToast(message: toastBinding)
        .task {
            if viewModel == nil {
                viewModel = EmailSignUpViewModel(auth: environment.auth)
            }
        }
    }
}

private extension EmailSignUpView {
    var toastBinding: Binding<String?> {
        Binding(
            get: { viewModel?.toastMessage },
            set: { viewModel?.toastMessage = $0 }
        )
    }

    var emailBinding: Binding<String> {
        Binding(get: { viewModel?.email ?? "" }, set: { viewModel?.updateEmail($0) })
    }

    var passwordBinding: Binding<String> {
        Binding(get: { viewModel?.password ?? "" }, set: { viewModel?.updatePassword($0) })
    }

    var passwordConfirmBinding: Binding<String> {
        Binding(get: { viewModel?.passwordConfirm ?? "" }, set: { viewModel?.updatePasswordConfirm($0) })
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("이메일로 가입하기")
                .textStyle(.headingLB)
                .foregroundStyle(Color.gray900)
            CMTextField(
                // TODO: [Figma 확인] 플레이스홀더 문구 확정 필요 (Figma에 없음)
                placeholder: "이메일을 입력해 주세요",
                text: emailBinding,
                label: "이메일",
                helper: viewModel?.emailHelper,
                errorMessage: viewModel?.emailErrorMessage,
                keyboardType: .emailAddress
            )
            CMTextField(
                placeholder: "비밀번호를 입력해 주세요",
                text: passwordBinding,
                label: "비밀번호",
                helper: "영문 · 숫자 · 특수문자 포함 8~20자",
                isSecure: true
            )
            CMTextField(
                placeholder: "비밀번호를 한 번 더 입력해 주세요",
                text: passwordConfirmBinding,
                label: "비밀번호 확인",
                errorMessage: viewModel?.passwordConfirmError,
                isSecure: true
            )
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var bottomCTA: some View {
        CMButton(title: "다음", size: .l, isFullWidth: true) {
            guard let viewModel else { return }
            Task {
                guard let result = await viewModel.submit() else { return }
                // TODO: [백엔드] 토큰 저장(Keychain). 가입 완료 후 약관(A-04) → 프로필(A-07)
                appState.completeLogin(isFirstTime: result.isFirstTime)
            }
        }
        .disabled(!(viewModel?.canSubmit ?? false))
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color.white)
    }
}

#Preview {
    NavigationStack {
        EmailSignUpView()
    }
    .environment(AppState())
}

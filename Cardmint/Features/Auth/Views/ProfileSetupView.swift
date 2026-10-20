//
//  ProfileSetupView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct ProfileSetupView: View {
    @Environment(\.appEnvironment) private var environment
    @Environment(AppState.self) private var appState
    @State private var viewModel: ProfileSetupViewModel?

    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            CMNavBar(style: .back, onLeading: onBack)
            ScrollView {
                content
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .dismissKeyboardOnTap()
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomCTA }
        .cmToast(message: toastBinding)
        .task {
            if viewModel == nil {
                viewModel = ProfileSetupViewModel(auth: environment.auth)
            }
        }
        .onChange(of: viewModel?.nickname) {
            viewModel?.enforceMaxLength()
        }
    }
}

private extension ProfileSetupView {
    var toastBinding: Binding<String?> {
        Binding(
            get: { viewModel?.toastMessage },
            set: { viewModel?.toastMessage = $0 }
        )
    }

    var nicknameBinding: Binding<String> {
        Binding(
            get: { viewModel?.nickname ?? "" },
            set: { viewModel?.updateNickname($0) }
        )
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 8) {
                Text("프로필을 설정해 주세요")
                    .textStyle(.headingLB)
                    .foregroundStyle(Color.gray900)
                Text("나중에 마이페이지에서 언제든 바꿀 수 있어요.")
                    .textStyle(.bodyMR)
                    .foregroundStyle(Color.gray600)
            }
            avatarSection
            CMTextField(
                // TODO: [Figma 확인] 플레이스홀더 문구 확정 필요 (Figma에 없음)
                placeholder: "닉네임을 입력해 주세요",
                text: nicknameBinding,
                label: "닉네임",
                helper: viewModel?.helper,
                errorMessage: viewModel?.errorMessage
            )
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var avatarSection: some View {
        ZStack(alignment: .bottomTrailing) {
            CMAvatar(name: viewModel?.nickname ?? "", size: .xl)
            CameraBadge {
                // TODO: [기능] 프로필 사진 선택 (PhotosPicker) 연결
            }
            .offset(x: 2, y: 2)
        }
        .frame(maxWidth: .infinity)
    }

    var bottomCTA: some View {
        CMButton(title: "카드민트 시작하기", size: .l, isFullWidth: true) {
            guard let viewModel else { return }
            Task {
                if await viewModel.submit() {
                    appState.completeProfile()
                }
            }
        }
        .disabled(!(viewModel?.canSubmit ?? false) || (viewModel?.isSubmitting ?? false))
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color.white)
    }
}

private struct CameraBadge: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(Color.white)
                Circle().strokeBorder(Color.gray200, lineWidth: 1)
                // TODO: [Figma 확인] 카메라 아이콘 색상 (임시 gray900)
                CMIcon(.camera, size: 18, color: .gray900)
            }
            .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("프로필 사진 변경")
    }
}

#Preview {
    ProfileSetupView(onBack: {})
        .environment(AppState())
}

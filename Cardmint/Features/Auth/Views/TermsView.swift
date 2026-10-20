//
//  TermsView.swift
//  Cardmint
//
//  Created by LHH on 10/19/26.
//

import SwiftUI

struct TermsView: View {
    @Environment(\.appEnvironment) private var environment
    @Environment(AppState.self) private var appState
    @State private var viewModel: TermsViewModel?

    let onBack: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            CMNavBar(style: .back, onLeading: onBack)
            content
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .safeAreaInset(edge: .bottom, spacing: 0) { bottomCTA }
        .cmToast(message: toastBinding)
        .task {
            if viewModel == nil {
                viewModel = TermsViewModel(auth: environment.auth)
            }
        }
    }
}

private extension TermsView {
    var toastBinding: Binding<String?> {
        Binding(
            get: { viewModel?.toastMessage },
            set: { viewModel?.toastMessage = $0 }
        )
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("카드민트 이용을 위해\n약관에 동의해 주세요")
                .textStyle(.headingLB)
                .foregroundStyle(Color.gray900)
            agreeAllRow
            VStack(spacing: 4) {
                ForEach(TermItem.allCases, id: \.self) { item in
                    TermRow(
                        item: item,
                        isSelected: viewModel?.isAgreed(item) ?? false,
                        onToggle: { viewModel?.toggle(item) },
                        onDetail: {
                            // TODO: [Figma 확인] 약관 상세 화면 없음. 확정 후 연결
                        }
                    )
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    var agreeAllRow: some View {
        Button {
            viewModel?.toggleAll()
        } label: {
            HStack(spacing: 12) {
                CMCheckCircle(isSelected: viewModel?.isAllAgreed ?? false)
                Text("약관 전체 동의")
                    .textStyle(.labelLSB)
                    .foregroundStyle(Color.gray900)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .background(Color.gray50)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    var bottomCTA: some View {
        CMButton(title: "동의하고 계속하기", size: .l, isFullWidth: true) {
            guard let viewModel else { return }
            Task {
                if await viewModel.submit() {
                    appState.acceptTerms()
                }
            }
        }
        .disabled(!(viewModel?.canProceed ?? false) || (viewModel?.isSubmitting ?? false))
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color.white)
    }
}

private struct TermRow: View {
    let item: TermItem
    let isSelected: Bool
    let onToggle: () -> Void
    let onDetail: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: onToggle) {
                HStack(alignment: .top, spacing: 12) {
                    CMIcon(.check, size: 22, color: isSelected ? .brandPrimary : .gray300)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.title)
                            .textStyle(.bodyMM)
                            .foregroundStyle(Color.gray900)
                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .textStyle(.caption)
                                .foregroundStyle(Color.gray400)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityAddTraits(isSelected ? .isSelected : [])

            if item.hasDetail {
                Button(action: onDetail) {
                    CMIcon(.chevronRight, size: 18, color: .gray400)
                        .frame(width: 30, height: 22, alignment: .trailing)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(item.title) 상세 보기")
            }
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    TermsView(onBack: {})
        .environment(AppState())
}

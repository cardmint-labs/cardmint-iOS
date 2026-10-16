//
//  CMDialog.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMDialog: View {
    enum Tone { case normal, danger }

    let title: String
    var message: String? = nil
    var tone: Tone = .normal
    var cancelTitle: String = "취소"
    var confirmTitle: String = "확인"
    let onCancel: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text(title)
                    .textStyle(.headingSSB)
                    .foregroundStyle(Color.gray900)
                if let message {
                    Text(message)
                        .textStyle(.bodySR)
                        .foregroundStyle(Color.gray600)
                }
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 28)
            .padding(.horizontal, 24)
            .padding(.bottom, 24)

            HStack(spacing: 8) {
                CMButton(title: cancelTitle, type: .outline, size: .m, isFullWidth: true, action: onCancel)
                CMButton(
                    title: confirmTitle,
                    type: tone == .danger ? .danger : .primary,
                    size: .m,
                    isFullWidth: true,
                    action: onConfirm
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(width: 313)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct CMDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let tone: CMDialog.Tone
    let cancelTitle: String
    let confirmTitle: String
    let onConfirm: () -> Void

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.gray950.opacity(0.5).ignoresSafeArea()
                        CMDialog(
                            title: title,
                            message: message,
                            tone: tone,
                            cancelTitle: cancelTitle,
                            confirmTitle: confirmTitle,
                            onCancel: { isPresented = false },
                            onConfirm: {
                                isPresented = false
                                onConfirm()
                            }
                        )
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.2), value: isPresented)
    }
}

extension View {
    func cmDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        tone: CMDialog.Tone = .normal,
        cancelTitle: String = "취소",
        confirmTitle: String = "확인",
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(CMDialogModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            tone: tone,
            cancelTitle: cancelTitle,
            confirmTitle: confirmTitle,
            onConfirm: onConfirm
        ))
    }
}

#Preview {
    ZStack {
        Color.gray950.opacity(0.5).ignoresSafeArea()
        CMDialog(
            title: "게시글을 삭제할까요?",
            message: "삭제한 게시글은 복구할 수 없어요.",
            tone: .danger,
            confirmTitle: "삭제",
            onCancel: {},
            onConfirm: {}
        )
    }
}

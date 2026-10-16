//
//  CMToast.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMToast: View {
    let message: String
    var icon: ImageResource = .alertCircle

    var body: some View {
        HStack(spacing: 8) {
            CMIcon(icon, size: 20, color: .white)
            Text(message)
                .textStyle(.bodySM)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .frame(minHeight: 48)
        .background(Color.gray900)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

private struct CMToastModifier: ViewModifier {
    @Binding var message: String?
    let duration: Double

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let text = message {
                    CMToast(message: text)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .task(id: text) {
                            try? await Task.sleep(for: .seconds(duration))
                            if !Task.isCancelled { message = nil }
                        }
                }
            }
            .animation(.easeOut(duration: 0.2), value: message)
    }
}

extension View {
    /// message에 문자열을 넣으면 표시되고, duration 뒤 nil로 돌아감
    func cmToast(message: Binding<String?>, duration: Double = 2.0) -> some View {
        modifier(CMToastModifier(message: message, duration: duration))
    }
}

#Preview {
    CMToast(message: "필수 항목을 입력해 주세요")
        .padding(16)
}

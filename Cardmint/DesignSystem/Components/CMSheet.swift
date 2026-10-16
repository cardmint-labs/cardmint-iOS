//
//  CMSheet.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMSheetHeader: View {
    let title: String
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray300)
                .frame(width: 36, height: 5)
                .padding(.top, 8)
            HStack(spacing: 0) {
                Text(title)
                    .textStyle(.headingSSB)
                    .foregroundStyle(Color.gray900)
                Spacer(minLength: 0)
                CMIconButton(.close, label: "닫기", action: onClose)
            }
            .padding(.leading, 16)
            .padding(.trailing, 12)
            .frame(height: 56)
        }
    }
}

private struct SheetHeightKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

/// 내용 높이에 맞춰 열리는 바텀시트 본문
struct CMSheetContainer<Content: View>: View {
    let title: String
    let onClose: () -> Void
    @ViewBuilder let content: () -> Content

    @State private var height: CGFloat = 300

    var body: some View {
        VStack(spacing: 0) {
            CMSheetHeader(title: title, onClose: onClose)
            content()
        }
        .frame(maxWidth: .infinity)
        .background {
            GeometryReader { proxy in
                Color.clear.preference(
                    key: SheetHeightKey.self,
                    value: proxy.size.height + proxy.safeAreaInsets.bottom
                )
            }
        }
        .onPreferenceChange(SheetHeightKey.self) { newValue in
            if newValue > 0 { height = newValue }
        }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(24)
        .presentationBackground(Color.white)
    }
}

extension View {
    func cmSheet<Content: View>(
        isPresented: Binding<Bool>,
        title: String,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        sheet(isPresented: isPresented) {
            CMSheetContainer(title: title, onClose: { isPresented.wrappedValue = false }, content: content)
        }
    }
}

#Preview {
    CMSheetHeader(title: "정렬", onClose: {})
}

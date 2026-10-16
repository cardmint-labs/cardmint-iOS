//
//  CMNavBar.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

enum CMNavBarStyle { case back, close, root, home }

struct CMNavBar<Trailing: View>: View {
    let style: CMNavBarStyle
    var title: String = ""
    var onLeading: () -> Void = {}
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        ZStack {
            if hasCenterTitle {
                // Figma: 타이틀 폭 233 (양쪽 72 여백)
                Text(title)
                    .textStyle(.labelLSB)
                    .foregroundStyle(Color.gray900)
                    .lineLimit(1)
                    .padding(.horizontal, 72)
            }
            HStack(spacing: 0) {
                leadingContent
                Spacer(minLength: 0)
                HStack(spacing: 0) { trailing() }
            }
        }
        .padding(.leading, hasCenterTitle ? 8 : 16)
        .padding(.trailing, 8)
        .frame(height: 52)
        .background(Color.white)
    }

    private var hasCenterTitle: Bool {
        style == .back || style == .close
    }

    @ViewBuilder
    private var leadingContent: some View {
        switch style {
        case .back:
            CMIconButton(.chevronLeft, label: "뒤로가기", iconSize: 26, action: onLeading)
        case .close:
            CMIconButton(.close, label: "닫기", iconSize: 26, action: onLeading)
        case .root:
            Text(title)
                .textStyle(.headingLB)
                .foregroundStyle(Color.gray900)
                .lineLimit(1)
        case .home:
            HStack(spacing: 6) {
                Image(.logoSymbol).resizable().scaledToFit().frame(height: 28)
                Image(.logoWord).resizable().scaledToFit().frame(height: 26)
            }
            .accessibilityHidden(true)
        }
    }
}

extension CMNavBar where Trailing == EmptyView {
    init(style: CMNavBarStyle, title: String = "", onLeading: @escaping () -> Void = {}) {
        self.init(style: style, title: title, onLeading: onLeading, trailing: { EmptyView() })
    }
}

/// NavBar 오른쪽 텍스트 액션 (예: 완료)
struct CMNavTextAction: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.labelMSB)
                .foregroundStyle(Color.brandPrimary)
                .padding(.horizontal, 12)
                .frame(height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        CMNavBar(style: .back, title: "상품 상세") {
            CMIconButton(.moreV, label: "더보기") {}
        }
        CMNavBar(style: .close, title: "신고하기")
        CMNavBar(style: .root, title: "채팅") {
            CMIconButton(.search, label: "검색") {}
        }
        CMNavBar(style: .home) {
            CMIconButton(.search, label: "검색", showsDot: true) {}
        }
        CMNavBar(style: .back, title: "수정") {
            CMNavTextAction(title: "완료") {}
        }
    }
}

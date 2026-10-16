//
//  CMIcon.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMDot: View {
    var body: some View {
        Circle()
            .fill(Color.pointRed)
            .frame(width: 6, height: 6)
    }
}

struct CMIcon: View {
    let resource: ImageResource
    var size: CGFloat = 24
    var color: Color = .gray900

    init(_ resource: ImageResource, size: CGFloat = 24, color: Color = .gray900) {
        self.resource = resource
        self.size = size
        self.color = color
    }

    var body: some View {
        Image(resource)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
}

/// 44x44 터치 영역을 가진 아이콘 버튼
struct CMIconButton: View {
    let resource: ImageResource
    let label: String
    var iconSize: CGFloat = 24
    var color: Color = .gray900
    var showsDot: Bool = false
    let action: () -> Void

    init(
        _ resource: ImageResource,
        label: String,
        iconSize: CGFloat = 24,
        color: Color = .gray900,
        showsDot: Bool = false,
        action: @escaping () -> Void
    ) {
        self.resource = resource
        self.label = label
        self.iconSize = iconSize
        self.color = color
        self.showsDot = showsDot
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                CMIcon(resource, size: iconSize, color: color)
                if showsDot {
                    CMDot().offset(x: 4, y: -12)
                }
            }
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

#Preview {
    HStack {
        CMIcon(.search)
        CMIconButton(.search, label: "검색", showsDot: true) {}
        CMIconButton(.moreV, label: "더보기") {}
    }
    .padding(16)
}

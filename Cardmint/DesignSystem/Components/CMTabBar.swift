//
//  CMTabBar.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

enum CMTab: CaseIterable {
    case home, search, add, chat, my
}

struct CMTabBar: View {
    let selected: CMTab
    var hasChatBadge: Bool = false
    let onSelect: (CMTab) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.gray200)
                .frame(height: 1)
            HStack(spacing: 0) {
                ForEach(Array(CMTab.allCases.enumerated()), id: \.offset) { index, tab in
                    if index > 0 { Spacer(minLength: 0) }
                    cell(for: tab)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 6)
            .frame(height: 49, alignment: .top)
        }
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
    
    @ViewBuilder
    private func cell(for tab: CMTab) -> some View {
        if tab == .add {
            addCell
        } else {
            tabCell(for: tab)
        }
    }
    
    private func tabCell(for tab: CMTab) -> some View {
        let isSelected = selected == tab
        let color: Color = isSelected ? .gray700 : .gray400
        return Button {
            onSelect(tab)
        } label: {
            VStack(spacing: 0) {
                CMIcon(iconResource(for: tab, isSelected: isSelected), size: 26, color: color)
                    .overlay {
                        if tab == .chat && hasChatBadge {
                            CMDot().offset(x: 11, y: -9)
                        }
                    }
                Text(title(for: tab))
                    .textStyle(isSelected ? .navigationSB : .navigation)
                    .foregroundStyle(color)
            }
            .frame(width: 64, height: 43, alignment: .top)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title(for: tab))
    }
    
    private var addCell: some View {
        Color.clear
            .frame(width: 64, height: 43)
            .overlay(alignment: .top) {
                Button {
                    onSelect(.add)
                } label: {
                    ZStack {
                        Circle().fill(Color.brandPrimary).frame(width: 52, height: 52)
                        Circle().stroke(Color.white, lineWidth: 4).frame(width: 56, height: 56)
                    }
                    .shadow(color: Color(hex: 0x0F6B63, opacity: 0.15), radius: 7, x: 0, y: 6)
                    .overlay {
                        CMIcon(.plus, size: 26, color: .white)
                    }
                    .frame(width: 60, height: 60)
                    .contentShape(Circle())
                }
                .buttonStyle(.plain)
                .offset(y: -28)
                .accessibilityLabel("등록")
            }
    }
    
    private func iconResource(for tab: CMTab, isSelected: Bool) -> ImageResource {
        switch tab {
        case .home: return isSelected ? .homeFill : .home
        case .search: return .search
        case .add: return .plus
        case .chat: return isSelected ? .chatFill : .chat
        case .my: return isSelected ? .userFill : .user
        }
    }
    
    private func title(for tab: CMTab) -> String {
        switch tab {
        case .home: return "홈"
        case .search: return "검색"
        case .add: return "등록"
        case .chat: return "채팅"
        case .my: return "마이"
        }
    }
}

#Preview {
    VStack {
        Spacer()
        CMTabBar(selected: .home, hasChatBadge: true) { _ in }
    }
}

//
//  CMBadge.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

enum CMBadgeType { case grade, selling, reserved, sold, info, neutral, danger, dark }

struct CMBadge: View {
    let title: String
    var type: CMBadgeType = .neutral

    var body: some View {
        Text(title)
            .badgeSB()
            .foregroundStyle(palette.foreground)
            .padding(.horizontal, 8)
            .frame(height: 24)
            .background(palette.background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var palette: (foreground: Color, background: Color) {
        switch type {
        case .grade: return (.white, .brandPrimary)
        case .selling: return (.brandPrimary, .brandSub)
        case .reserved: return (.white, .gray900)
        case .sold: return (.gray400, .gray100)
        case .info, .neutral: return (.gray600, .gray100)
        case .danger: return (.pointRed, .pointRedSub)
        case .dark: return (.white, .gray900)
        }
    }
}

#Preview {
    HStack {
        CMBadge(title: "PSA 10", type: .grade)
        CMBadge(title: "판매중", type: .selling)
        CMBadge(title: "예약중", type: .reserved)
        CMBadge(title: "판매완료", type: .sold)
        CMBadge(title: "삭제됨", type: .danger)
    }
    .padding(16)
}

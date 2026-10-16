//
//  CMRankBadge.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMRankBadge: View {
    let rank: Int

    var body: some View {
        Text("\(rank)")
            .badgeSB()
            .foregroundStyle(Color.white)
            .frame(width: 24, height: 24)
            .background(fill)
            .clipShape(Circle())
    }

    private var fill: Color {
        switch rank {
        case ...1: return .brandPrimary
        case 2: return .gray700
        case 3: return .gray500
        default: return .gray400
        }
    }
}

#Preview {
    HStack {
        ForEach(1...5, id: \.self) { CMRankBadge(rank: $0) }
    }
    .padding(16)
}

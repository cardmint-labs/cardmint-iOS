//
//  CMLikeBadge.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMLikeBadge: View {
    let count: Int

    var body: some View {
        HStack(spacing: 3) {
            CMIcon(.heartFill, size: 12, color: .gray900)
            Text("\(count)")
                .textStyle(.badgeSB)
                .foregroundStyle(Color.gray900)
        }
        .padding(.horizontal, 8)
        .frame(height: 24)
        .background(Color.white)
        .clipShape(Capsule())
        .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 1)
        .accessibilityLabel("좋아요 \(count)개")
    }
}

#Preview {
    CMLikeBadge(count: 32)
        .padding(16)
}

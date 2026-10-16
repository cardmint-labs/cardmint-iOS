//
//  CMCountBadge.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMCountBadge: View {
    let count: Int

    var body: some View {
        Text("\(count)")
            .textStyle(.badgeSB)
            .foregroundStyle(Color.white)
            .padding(.horizontal, 6)
            .frame(minWidth: 20, minHeight: 20)
            .background(Color.pointRed)
            .clipShape(Capsule())
            .accessibilityLabel("\(count)개")
    }
}

#Preview {
    HStack(spacing: 8) {
        CMCountBadge(count: 2)
        CMCountBadge(count: 32)
    }
    .padding(16)
}

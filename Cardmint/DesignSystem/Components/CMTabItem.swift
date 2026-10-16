//
//  CMTabItem.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMTabItem: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(isSelected ? .labelMSB : .bodyMM)
                .foregroundStyle(isSelected ? Color.gray900 : Color.gray400)
                .padding(.horizontal, 12)
                .frame(height: 48)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(isSelected ? Color.gray900 : Color.gray200)
                        .frame(height: isSelected ? 2 : 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HStack(spacing: 0) {
        CMTabItem(title: "탭", isSelected: true) {}
        CMTabItem(title: "탭", isSelected: false) {}
    }
}

//
//  CMListRow.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMListRow: View {
    let title: String
    var icon: ImageResource? = nil
    var value: String? = nil
    var showsChevron: Bool = true

    var body: some View {
        HStack(spacing: 12) {
            if let icon {
                CMIcon(icon, size: 22, color: .gray500)
            }
            Text(title)
                .textStyle(.bodyMM)
                .foregroundStyle(Color.gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let value {
                Text(value)
                    .textStyle(.bodySR)
                    .foregroundStyle(Color.gray400)
            }
            if showsChevron {
                CMIcon(.chevronRight, size: 18, color: .gray400)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack(spacing: 0) {
        CMListRow(title: "메뉴", icon: .receipt)
        CMListRow(title: "메뉴", icon: .receipt, value: "값")
        CMListRow(title: "메뉴", showsChevron: false)
    }
}

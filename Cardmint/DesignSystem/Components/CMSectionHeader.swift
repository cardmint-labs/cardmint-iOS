//
//  CMSectionHeader.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMSectionHeader: View {
    let title: String
    var icon: ImageResource? = nil
    var iconColor: Color = .pointRed
    var caption: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                CMIcon(icon, size: 22, color: iconColor)
            }
            Text(title)
                .textStyle(.headingSSB)
                .foregroundStyle(Color.gray900)
                .frame(maxWidth: .infinity, alignment: .leading)
            if let caption {
                Text(caption)
                    .textStyle(.caption)
                    .foregroundStyle(Color.gray400)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack(spacing: 0) {
        CMSectionHeader(title: "섹션 타이틀", icon: .fire, caption: "매일 00시 갱신")
        CMSectionHeader(title: "섹션 타이틀")
    }
}

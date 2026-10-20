//
//  CMCheck.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMCheckbox: View {
    let isSelected: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(isSelected ? Color.brandSecondary : Color.white)
            .frame(width: 22, height: 22)
            .overlay {
                if isSelected {
                    CMIcon(.check, size: 16, color: .white)
                } else {
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color.gray300, lineWidth: 1.5)
                }
            }
    }
}

struct CMCheckCircle: View {
    let isSelected: Bool

    var body: some View {
        Circle()
            .fill(isSelected ? Color.brandPrimary : Color.white)
            .frame(width: 22, height: 22)
            .overlay {
                if isSelected {
                    CMIcon(.check, size: 14, color: .white)
                } else {
                    Circle()
                        .strokeBorder(Color.gray300, lineWidth: 1.5)
                }
            }
    }
}

#Preview {
    HStack(spacing: 16) {
        CMCheckbox(isSelected: true)
        CMCheckbox(isSelected: false)
        CMCheckCircle(isSelected: true)
        CMCheckCircle(isSelected: false)
    }
    .padding(16)
}

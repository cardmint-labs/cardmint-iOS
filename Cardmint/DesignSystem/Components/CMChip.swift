//
//  CMChip.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

enum CMChipSize { case m, s }

struct CMChip: View {
    let title: String
    var isSelected: Bool = false
    var size: CMChipSize = .m
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(size == .m ? .labelSM : .captionM)
                .foregroundStyle(isSelected ? Color.gray50 : Color.gray600)
                .padding(.horizontal, size == .m ? 14 : 12)
                .frame(height: size == .m ? 36 : 30)
                .background(isSelected ? selectedFill : Color.gray50)
                .clipShape(Capsule())
                .overlay {
                    if !isSelected {
                        Capsule().strokeBorder(Color.gray200, lineWidth: 1)
                    }
                }
        }
        .buttonStyle(.plain)
    }

    private var selectedFill: Color {
        size == .m ? .brandPrimary : .brandSecondary
    }
}

#Preview {
    HStack {
        CMChip(title: "전체", isSelected: true) {}
        CMChip(title: "PSA") {}
        CMChip(title: "BGS", size: .s) {}
        CMChip(title: "CGC", isSelected: true, size: .s) {}
    }
    .padding(16)
}

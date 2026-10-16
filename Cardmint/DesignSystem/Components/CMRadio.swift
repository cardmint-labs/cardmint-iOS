//
//  CMRadio.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMRadio: View {
    let isSelected: Bool

    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 22, height: 22)
            .overlay {
                Circle()
                    .strokeBorder(
                        isSelected ? Color.brandPrimary : Color.gray300,
                        lineWidth: isSelected ? 6 : 1.5
                    )
            }
    }
}

#Preview {
    HStack {
        CMRadio(isSelected: true)
        CMRadio(isSelected: false)
    }
    .padding(16)
}

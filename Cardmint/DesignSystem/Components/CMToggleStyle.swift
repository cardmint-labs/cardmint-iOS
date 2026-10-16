//
//  CMToggleStyle.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

struct CMToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            ZStack(alignment: configuration.isOn ? .trailing : .leading) {
                Capsule()
                    .fill(configuration.isOn ? Color.brandPrimary : Color.gray100)
                Circle()
                    .fill(Color.white)
                    .frame(width: 27, height: 27)
                    .shadow(color: Color.gray950.opacity(0.15), radius: 2, x: 0, y: 2)
                    .padding(2)
            }
            .frame(width: 51, height: 31)
            .animation(.easeOut(duration: 0.15), value: configuration.isOn)
        }
        .buttonStyle(.plain)
        .accessibilityValue(configuration.isOn ? "켜짐" : "꺼짐")
        .accessibilityAddTraits(.isToggle)
    }
}

extension ToggleStyle where Self == CMToggleStyle {
    static var cm: CMToggleStyle { CMToggleStyle() }
}

#Preview {
    VStack(spacing: 16) {
        Toggle("알림", isOn: .constant(true)).toggleStyle(.cm).labelsHidden()
        Toggle("알림", isOn: .constant(false)).toggleStyle(.cm).labelsHidden()
    }
    .padding(16)
}

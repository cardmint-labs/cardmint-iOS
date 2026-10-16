//
//  CMButton.swift
//  Cardmint
//
//  Created by LHH on 10/16/26.
//

import SwiftUI

enum CMButtonType { case primary, secondary, outline, ghost, danger, kakao, naver }
enum CMButtonSize { case l, m, s }

struct CMButton: View {
    @Environment(\.isEnabled) private var isEnabled

    let title: String
    var type: CMButtonType = .primary
    var size: CMButtonSize = .m
    var icon: Image? = nil
    var isFullWidth: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let icon { icon }
                Text(title).textStyle(size.textStyle)
            }
            .foregroundStyle(palette.foreground)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: size.height)
            .background(palette.background)
            .clipShape(RoundedRectangle(cornerRadius: size.radius))
            .overlay {
                if let border = palette.border {
                    RoundedRectangle(cornerRadius: size.radius)
                        .strokeBorder(border, lineWidth: 1)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private struct Palette {
        let foreground: Color
        let background: Color
        var border: Color? = nil
    }

    private var palette: Palette {
        guard isEnabled else { return Palette(foreground: .gray300, background: .gray100) }
        switch type {
        case .primary: return Palette(foreground: .white, background: .brandPrimary)
        case .secondary: return Palette(foreground: .gray900, background: .brandSub)
        case .outline: return Palette(foreground: .gray900, background: .white, border: .gray200)
        case .ghost: return Palette(foreground: .gray600, background: .clear)
        case .danger: return Palette(foreground: .white, background: .pointRed)
        case .kakao: return Palette(foreground: .gray950, background: .socialKakao)
        case .naver: return Palette(foreground: .white, background: .socialNaver)
        }
    }
}

private extension CMButtonSize {
    var height: CGFloat {
        switch self {
        case .l: return 56
        case .m: return 48
        case .s: return 36
        }
    }

    var radius: CGFloat {
        switch self {
        case .l, .m: return 12
        case .s: return 10
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .l: return 20
        case .m: return 16
        case .s: return 12
        }
    }

    var textStyle: TextStyle {
        switch self {
        case .l: return .buttonLB
        case .m: return .buttonMSB
        case .s: return .labelSM
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        CMButton(title: "채팅하기", type: .primary, size: .l, isFullWidth: true) {}
        CMButton(title: "취소", type: .outline, size: .m) {}
        CMButton(title: "삭제", type: .danger, size: .s) {}
        CMButton(title: "비활성", size: .m) {}.disabled(true)
    }
    .padding(16)
}

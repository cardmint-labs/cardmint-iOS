//
//  Color+Token.swift
//  Cardmint
//
//  Created by LHH on 10/14/26.
//

import SwiftUI

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }

    // Brand
    static let brandPrimary = Color(hex: 0x00CBBA)
    static let brandSecondary = Color(hex: 0x01DDB6)
    static let brandAccent = Color(hex: 0x0E1F1C)
    static let brandSub = Color(hex: 0xDFFFF4)

    // Gray
    static let gray25 = Color(hex: 0xFDFDFD)
    static let gray50 = Color(hex: 0xFEFEFE)
    static let gray100 = Color(hex: 0xF5F5F5)
    static let gray200 = Color(hex: 0xE9EAEB)
    static let gray300 = Color(hex: 0xD5D7DA)
    static let gray400 = Color(hex: 0xA4A7AE)
    static let gray500 = Color(hex: 0x717680)
    static let gray600 = Color(hex: 0x535862)
    static let gray700 = Color(hex: 0x414651)
    static let gray800 = Color(hex: 0x252B37)
    static let gray900 = Color(hex: 0x181D27)
    static let gray950 = Color(hex: 0x0A0D12)

    // Point
    static let pointRed = Color(hex: 0xFF274B)
    static let pointYellow = Color(hex: 0xFFCC00)
    static let pointRedSub = Color(hex: 0xFFEEF1)
    
    // Social
    static let socialKakao = Color(hex: 0xFEE500)
    static let socialNaver = Color(hex: 0x03C75A)
}
